package QuizWell::Schema::Result::Tag;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('tags');

__PACKAGE__->add_columns(
  id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },

  name => {
    data_type => 'text',
    is_nullable => 0
  },

  color => {
    data_type => 'text',
    is_nullable => 0,
  },

  created_at => {
    data_type => 'datetime',
    is_nullable => 0,
    default_value => \'current_timestamp',
  },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraints([ qw/name/ ]);
__PACKAGE__->has_many('question_tags', 'QuizWell::Schema::Result::QuestionTag',
  'tag_id');

1;