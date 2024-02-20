use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";

use QuizWell::Schema;

my $schema = QuizWell::Schema->connect('dbi:Pg:');

$schema->upgrade();