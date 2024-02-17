package QuizWell::Controller::Quiz;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub generate($self) {
  my $job_description = $self->req->json;
  use Data::Dumper;
  say Dumper($job_description);
  $self->render(json => {status => 'ok'});
}

1;