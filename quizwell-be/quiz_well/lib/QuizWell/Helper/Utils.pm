package QuizWell::Helper::Utils;

use v5.36;
use String::Random qw/random_regex/;

use parent qw/Exporter/;
our @EXPORT = qw/
  generate_uuid
/;

our @EXPORT_OK = @EXPORT;
our $VERSION = '1';

sub generate_uuid($resultset, $column_name) {
  while (1) {
    my $uuid = random_regex('[A-Za-z0-9]{16}');
    return $uuid unless $resultset->find({ $column_name => $uuid });
  }
  my $uuid = random_regex('[A-Za-z0-9]{16}');
}

1;