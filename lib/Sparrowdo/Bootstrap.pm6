use v6;

unit module Sparrowdo::Bootstrap;
use Sparrow6::Runner;

sub bootstrap-script () is export {

  my $script = os-resolver();

  $script ~= "\n\n";

  $script ~= slurp %?RESOURCES<bootstrap.sh>.Str;

  return $script;

}
