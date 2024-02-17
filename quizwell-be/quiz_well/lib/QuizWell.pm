package QuizWell;
use Mojo::Base 'Mojolicious', -signatures;

use QuizWell::Schema;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});

  my $schema = QuizWell::Schema->connect('dbi:Pg:');
  $self->helper(db => sub { return $schema; });
  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/api')->to('Example#welcome');
  $r->post('/api/quiz/generate')->name('generate_quiz')->to('Quiz#generate');
}

1;
