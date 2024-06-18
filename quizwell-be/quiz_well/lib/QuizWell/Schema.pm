package QuizWell::Schema;

use base qw/DBIx::Class::Schema/;

our $VERSION = 4;

__PACKAGE__->load_namespaces();

__PACKAGE__->load_components(qw/Schema::Versioned/);

__PACKAGE__->upgrade_directory('../script/sql/');

1;