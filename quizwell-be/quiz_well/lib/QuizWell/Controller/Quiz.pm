package QuizWell::Controller::Quiz;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw(decode_json);
use Mojo::Message::Request;
use Try::Tiny;

use QuizWell::Helper::Utils;

sub generate($self) {
  my $job_description = $self->req->json->{jobDescription};
  my $chatgpt_prompt = <<END_PROMPT;
I am preparing for an interview which will consist of multiple choice questions.
The job description is as follows:
$job_description

Generate a quiz with 10 multiple choice questions together with the correct 
answer/answers. Prioritize coding questions whenever possible.

The response should be in json in the following format:
questions: [
  {
    question text formatted in markdown,
    answers: array of possible answers,
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
      
  return $self->render(json => {status => 'ok'});
}

1;