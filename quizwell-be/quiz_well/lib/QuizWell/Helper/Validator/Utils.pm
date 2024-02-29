package QuizWell::Helper::Validator::Utils;

use v5.36;

use parent qw/Exporter/;
our @EXPORT = qw/
  validate_exists_in_resultset
/;

our @EXPORT_OK = @EXPORT;
our $VERSION = '1';

sub validate_exists_in_resultset($app, $result_set_name, $object_value, 
    $object_key = 'id') {
  
  my $object = $app->db->resultset($result_set_name)->find({ 
    $object_key => $object_value 
  });
  return $object if $object;
  $app->render(
    json => {
      error => "$result_set_name does not exist"
    },
    status => 400
  );
  return 0;
}
1;