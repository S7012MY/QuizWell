package QuizWell::Schema::Result::Question;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('questions');

__PACKAGE__->add_columns(
  id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },

  md => {
    data_type => 'text',
    is_nullable => 0
  },

  created_at => {
    data_type => 'datetime',
    is_nullable => 0,
    default_value => \'current_timestamp',
  },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraints([ qw/md/ ]);
__PACKAGE__->has_many('answers', 'QuizWell::Schema::Result::QuestionAnswer', 
  'question_id');
__PACKAGE__->has_many('question_tags', 'QuizWell::Schema::Result::QuestionTag',
  'question_id');
__PACKAGE__->has_many('quiz_answers', 'QuizWell::Schema::Result::QuizAnswer',
  'question_id');
__PACKAGE__->has_many('quiz_questions', 
  'QuizWell::Schema::Result::QuizQuestion', 'question_id');
__PACKAGE__->has_many('tags', 'QuizWell::Schema::Result::QuestionTag',
  'question_id');

1;