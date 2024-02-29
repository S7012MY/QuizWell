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

  # Quiz routes
  $r->post('/api/quiz/generate')->name('generate_quiz')->to('Quiz#generate');
  $r->get('/api/quiz/:uuid')->name('get_quiz')->to('Quiz#get');
  $r->post('/api/quiz/:uuid/answer')->name('answer_quiz')
    ->to('Quiz#answer');
  $r->get('/api/quiz/:uuid/question')->name('get_quiz_question')
    ->to('Quiz#question');
  $r->get('/api/quiz/:uuid/result')->name('get_quiz_result')->to('Quiz#result');
  $r->post('/api/quiz/:uuid/start')->name('start_quiz')->to('Quiz#start');
  $r->get('/api/quiz/:uuid/status')->name('get_quiz_status')->to('Quiz#status');
}

1;
