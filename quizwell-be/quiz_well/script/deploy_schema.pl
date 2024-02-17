use v5.36;
use FindBin;
use lib "$FindBin::Bin/../lib";

use QuizWell::Schema;

my $schema = QuizWell::Schema->connect('dbi:Pg:');
say $schema->schema_version();

$schema->deploy();