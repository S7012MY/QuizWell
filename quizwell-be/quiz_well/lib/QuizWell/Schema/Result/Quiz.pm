package QuizWell::Schema::Result::Quiz;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('quizzes');

__PACKAGE__->add_columns(
  id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },

  uuid => {
    data_type => 'text',
    is_nullable => 0
  },

  current_question => {
    data_type => 'integer',
    is_nullable => 1
  },

  created_at => {
    data_type => 'datetime',
    is_nullable => 0,
    default_value => \'current_timestamp',
  },

  # Prompt used for generating the quiz
  prompt => {
    data_type => 'text',
    is_nullable => 1
  },

  # Columns used for storing start and end time of each quiz
  start_time => {
    data_type => 'datetime',
    is_nullable => 1,
  },

  end_time => {
    data_type => 'datetime',
    is_nullable => 1,
  }
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraints([ qw/uuid/ ]);
__PACKAGE__->belongs_to('current_question', 
  'QuizWell::Schema::Result::Question', 'current_question');
__PACKAGE__->has_many('quiz_answers', 'QuizWell::Schema::Result::QuizAnswer',
  'quiz_id');
__PACKAGE__->has_many('quiz_questions', 
  'QuizWell::Schema::Result::QuizQuestion', 'quiz_id');

1;