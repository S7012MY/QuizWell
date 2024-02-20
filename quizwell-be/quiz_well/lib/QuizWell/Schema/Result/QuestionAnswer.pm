package QuizWell::Schema::Result::QuestionAnswer;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('question_answers');

# Possible answers to a question
__PACKAGE__->add_columns(
  id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },

  question_id => {
    data_type => 'integer',
    is_nullable => 0
  },

  md => {
    data_type => 'text',
    is_nullable => 0
  },

  is_correct => {
    data_type => 'boolean',
    is_nullable => 0
  },
  
  created_at => {
    data_type => 'datetime',
    default_value => \'current_timestamp',
  },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('question', 'QuizWell::Schema::Result::Question', 
  'question_id');
__PACKAGE__->has_many('quiz_answers', 'QuizWell::Schema::Result::QuizAnswer',
  'answer_id');

1;