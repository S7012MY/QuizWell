package QuizWell::Controller::Quiz;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Message::Request;

sub generate($self) {
  my $job_description = $self->req->json->{jobDescription};
  use Data::Dumper;
  say Dumper($job_description);
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
  my $actual_response = $gpt_response->json->{choices}[0]{message}{content};
  say $actual_response;
      
  $self->render(json => {status => 'ok'});
}

1;