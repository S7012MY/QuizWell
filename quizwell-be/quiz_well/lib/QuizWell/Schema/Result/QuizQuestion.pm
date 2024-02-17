package QuizWell::Schema::Result::QuizQuestion;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('quiz_questions');

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

  position => {
    data_type => 'integer',
    is_nullable => 0
  },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraints([ qw/quiz_id question_id/ ]);
__PACKAGE__->belongs_to('quiz', 'QuizWell::Schema::Result::Quiz', 
  'quiz_id');
__PACKAGE__->belongs_to('question', 'QuizWell::Schema::Result::Question',
  'question_id');
__PACKAGE__->has_many('quiz_current_questions', 
  'QuizWell::Schema::Result::Quiz', 'current_question');

1;