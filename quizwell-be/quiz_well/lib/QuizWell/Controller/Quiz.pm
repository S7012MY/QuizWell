package QuizWell::Controller::Quiz;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw(decode_json);
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
  my $chatgpt_prompt = <<END_PROMPT;
I am preparing for an interview which will consist of multiple choice questions.
The job description is as follows:
$job_description

Generate a quiz with 10 multiple choice questions together with the correct 
answer/answers. Prioritize on choosing questions involving programming or snippets of code whenever possible.

The response should be in json in the following format:
questions: [
  {
    question text formatted using html,
    answers: array of possible answers each answer formatted as html,
    correctAnswers: array of numbers representing the correct answer/answers. Assume the possible answers are numbered starting from 0,
    tags: array of tags
  },
  ...
]
END_PROMPT

  # Calling the GPT API
  my $gpt_response = $self->ua->post('https://api.openai.com/v1/chat/completions',
    {Authorization
      => 'Bearer ' . $self->app->config->{openai_key},
      'Content-Type' => 'application/json'},
    json => {
      model => 'gpt-3.5-turbo',
      messages => [
        {role => 'user', content => $chatgpt_prompt}
      ]
    }
  )->result;
  my $actual_response = decode_json 
    $gpt_response->json->{choices}[0]{message}{content};
  
  my $quiz_uuid = generate_uuid($self->db->resultset('Quiz'), 'uuid');

  try {
    $self->db->txn_do(sub {
      my $quiz = $self->db->resultset('Quiz')->create({uuid => $quiz_uuid});
      my $question_position = 0;
      for my $question ($actual_response->{questions}->@*) {
        my $question_text = $question->{question};
        my $question_record = $self->db->resultset('Question')->create({
          md => $question_text
        });
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
    say "Failed to create quiz: $_";
    return $self->render(json => {status => 'error', message => 'Failed to create quiz'});
  };
      
  return $self->render(json => {uuid => $quiz_uuid});
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