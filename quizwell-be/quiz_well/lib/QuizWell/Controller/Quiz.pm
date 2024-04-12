package QuizWell::Controller::Quiz;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use utf8;

use Mojo::JSON qw(decode_json);
use Mojo::Log;
use Mojo::Message::Request;
use Try::Tiny;

use QuizWell::Helper::Utils;
use QuizWell::Helper::Validator::Utils;

sub answer($self) {
  my $quiz_uuid = $self->param('uuid');

  return unless my $quiz = 
    validate_exists_in_resultset($self, 'Quiz', $quiz_uuid, 'uuid');
  return $self->render(json => {error => 'Quiz not in progress'}) 
    unless $quiz->current_question;
  
  # TODO: Add validation that answers are submitted to the correct question

  say $quiz->id;
  say $quiz->current_question->id;
  my $current_question = $quiz->current_question;
  my $quiz_current_question = $quiz->quiz_questions
    ->find({ quiz_id => $quiz->id, question_id => $current_question->id });
  my @answer_ids = $self->req->json->{answerIds}->@*;
  my $next_question = $quiz_current_question->next_sibling;

  try {
    $self->db->txn_do(sub {
      for my $answer_id (@answer_ids) {
        $self->db->resultset('QuizAnswer')->create({
          quiz_id => $quiz->id,
          question_id => $current_question->id,
          answer_id => $answer_id
        });
      }
      
      $quiz->update({current_question => $next_question->id })
        if $next_question;
      
      $quiz->update({current_question => undef})
        unless $next_question;
    });
  } catch {
    say "Failed to answer quiz: $_";
    return $self->render(json => {status => 'error', message => 'Failed to answer quiz'});
  };
  return $self->render(json => {status => 'ok', hasNextQuestion => $next_question ? 1 : 0});
}

sub generate($self) {
  my $job_description = $self->req->json->{jobDescription};
  # TODO Move this to a validation module
  return $self->render(json => {error => 'Job description too long'}) 
    if length($job_description) > 3000;
  my $system_prompt = <<END_PROMPT;
You are an expert software engineer with special knowledge in interviewing and recruiting software engineers.
You want to hire a senior software engineer based on a job description that you will receive as input from the user.

First of all you extract only the technologies, frameworks and programming languages from the job description because you only focus on the technical aspects.
Rate each of the extracted technologies, frameworks and programming languages based on how important they are for the job you're hiring right now.
Use them to generate a multiple choice quiz having 10 questions involving those extracted technologies.
Generated questions should only involve technologies, frameworks and programming languages mentioned in the job descriptions.
Generated questions should not be about the job description itself.
The level of difficulty should be senior level.
75% of the questions should be practical and involve complex code snippets, each snippet having at least 10 lines of code.

Ensure that the quiz contains a total of 10 questions.
If the extracted information does not result in 10 questions, generate additional questions based on the available data.

The response should be encoded using valid JSON in the following format. It shouldn't contain any other information apart from the quiz questions and answers.
{
  questions: [
    {
      question: string, //question text formatted using html (be careful to escape double quotes for this field),
      answers: [string], // array of possible answers each answer formatted as html (be careful to escape double quotes in the elements of this array),
      explanation: string, //explanation of the correct answer(s) formatted as html (be careful to escape double quotes for this field),
      correctAnswers: [int], // array of numbers representing the correct answer/answers. Assume the possible answers are numbered starting from 0,
      tags: [string], // array of tags
    }, // array of 10 question objects
  ],
  error: string, // in case an error happens, this field should be present and contain the error message,
  warning: string //in case there is a warning, this field should be present and contain the warning message
}

Example question if the job description is for a Python position:
{
  "tags": [
    "Python",
    "Functional Programming"
  ],
  "answers": [
    "[1, 2, 3, 4, 5, 1, 2, 3, 4, 5]",
    "[2, 4, 6, 8, 10]",
    "[1, 2, 3, 4, 5, 2, 4, 6, 8, 10]",
    "None of the above"
  ],
  "question": "What is the output of the following Python code snippet? <br />nums = [1, 2, 3, 4, 5] <br />nums = list(map(lambda x: x*2, nums)) <br />print(nums)",
  "explanation": "The map function applies the lambda function to each element of the 'nums' list, therefore outputting: [2, 4, 6, 8, 10].",
  "correctAnswers": [
    1
  ]
}

END_PROMPT
  my $quiz_uuid;
  my $had_error = 0;
  try {
    # Calling the GPT API
    $self->ua->inactivity_timeout(300);
    my $gpt_response = $self->ua->post('https://api.openai.com/v1/chat/completions',
      {Authorization
        => 'Bearer ' . $self->app->config->{openai_key},
        'Content-Type' => 'application/json'},
      json => {
        model => 'gpt-4',
        messages => [
          {role => 'system', content => $system_prompt},
          {role => 'user', content => $job_description}
        ]
      }
    )->result;
    use Data::Dumper;
    say Dumper($gpt_response->json);
    my $actual_response = decode_json $gpt_response->json->{choices}[0]{message}{content};
    if ($actual_response->{error}) {
      die $actual_response->{error};
    }
    
    $quiz_uuid = generate_uuid($self->db->resultset('Quiz'), 'uuid');

    $self->db->txn_do(sub {
      my $quiz = $self->db->resultset('Quiz')->create({
        uuid => $quiz_uuid,
        prompt => $system_prompt . "\n\n\n\n----$job_description",
      });
      my $question_position = 1;
      for my $question ($actual_response->{questions}->@*) {
        say Dumper($question);
        my $question_text = $question->{question};
        my $question_record = $self->db->resultset('Question')->find({
          md => $question_text
        });
        $question_record = $self->db->resultset('Question')->create({
          md => $question_text
        }) unless $question_record;

        $self->db->resultset('QuizQuestion')->create({
          quiz_id => $quiz->id,
          question_id => $question_record->id,
          position => $question_position++
        });
        for my $i (0..$question->{answers}->@* - 1) {
          my $answer = $question->{answers}[$i];
          my $is_correct = grep {$_ == $i} $question->{correctAnswers}->@*;
          $self->db->resultset('QuestionAnswer')->create({
            question_id => $question_record->id,
            md => $answer,
            is_correct => $is_correct
          });
        }
        for my $tag ($question->{tags}->@*) {
          my $tag_record = $self->db->resultset('Tag')->find_or_create({
            name => $tag,
            # Generate a random color code
            color => sprintf("#%06x", int(rand(0xffffff)))

          });
          $self->db->resultset('QuestionTag')->create({
            question_id => $question_record->id,
            tag_id => $tag_record->id
          });
        }
      }
    });
  } catch {
    # Log the error
    my $log = Mojo::Log->new(path => '/var/log/quizwell.log');
    $log->error("Failed to generate quiz: $_");
    say "Failed to create quiz: $_";
    $had_error = 1;
    return $self->render(json => {error => "Failed to generate quiz: $_"});
  };
      
  $self->render(json => {uuid => $quiz_uuid}) unless $had_error;
}

sub question($self) {
  my $quiz_uuid = $self->param('uuid');
  return unless my $quiz = 
    validate_exists_in_resultset($self, 'Quiz', $quiz_uuid, 'uuid');
  return $self->render(json => {error => 'Quiz not in progress'}) 
    unless $quiz->current_question;

  my $current_question = $quiz->current_question;
  my @answers = $current_question->answers->all;
  my $question_data = {
    question => $current_question->md,
    answers => [map { {id => $_->id, md => $_->md} } @answers],
  };
  return $self->render(json => $question_data);

}

sub result($self) {
  my $quiz_uuid = $self->param('uuid');
  return unless my $quiz = 
    validate_exists_in_resultset($self, 'Quiz', $quiz_uuid, 'uuid');
  return $self->render(json => {error => 'Quiz not completed'}) 
    if $quiz->current_question || $quiz->quiz_answers->count == 0;

  my @quiz_questions = $quiz->quiz_questions->all;
  my @question_answers = map { 
    {
      text => $_->question->md,
      answers => [map { {id => $_->id, md => $_->md, is_correct => $_->is_correct} } $_->question->answers->all],
      user_answers => [map { $_->answer_id } $quiz->quiz_answers->search({ question_id => $_->question->id})->all]
    }

  } @quiz_questions;

  return $self->render(json => {questions => \@question_answers});
}

sub start($self) {
  my $quiz_uuid = $self->param('uuid');
  return unless my $quiz = 
    validate_exists_in_resultset($self, 'Quiz', $quiz_uuid, 'uuid');
  my $first_question = $quiz->quiz_questions
    ->search({}, {order_by => 'position'})->first;
  $quiz->update({current_question => $first_question->id });
  return $self->render(json => {status => 'ok'});
}

sub status($self) {
  my $quiz_uuid = $self->param('uuid');
  return unless my $quiz = 
    validate_exists_in_resultset($self, 'Quiz', $quiz_uuid, 'uuid');
  return $self->render(json => {status => 'NOT_STARTED'}) 
    if !$quiz->current_question && $quiz->quiz_answers->count == 0;
  return $self->render(json => {status => 'COMPLETED'}) 
    if !$quiz->current_question && $quiz->quiz_answers;
  return $self->render(json => {status => 'IN_PROGRESS'});
}

1;