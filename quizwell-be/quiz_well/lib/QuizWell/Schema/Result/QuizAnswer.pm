package QuizWell::Schema::Result::QuizAnswer;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('quiz_answers');

__PACKAGE__->add_columns(
  id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },

  quiz_id => {
    data_type => 'integer',
    is_nullable => 0
  },

  question_id => {
    data_type => 'integer',
    is_nullable => 0
  },

  answer_id => {
    data_type => 'integer',
    is_nullable => 0
  },

  created_at => {
    data_type => 'datetime',
    is_nullable => 0,
    default_value => \'current_timestamp',
  }
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('quiz', 'QuizWell::Schema::Result::Quiz', 'quiz_id');
__PACKAGE__->belongs_to('question', 'QuizWell::Schema::Result::Question', 
  'question_id');
__PACKAGE__->belongs_to('answer', 'QuizWell::Schema::Result::QuestionAnswer', 
  'answer_id');

1;
