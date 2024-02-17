package QuizWell::Schema::Result::QuestionTag;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('question_tags');

__PACKAGE__->add_columns(
  id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },

  question_id => {
    data_type => 'integer',
    is_nullable => 0
  },

  tag_id => {
    data_type => 'integer',
    is_nullable => 0
  },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraints([ qw/question_id tag_id/ ]);
__PACKAGE__->belongs_to('question', 'QuizWell::Schema::Result::Question', 
  'question_id');
__PACKAGE__->belongs_to('tag', 'QuizWell::Schema::Result::Tag',
  'tag_id');

1;