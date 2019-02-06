use v6;

unit module Sparrowdo::Utils;

use Sparrowdo::Bootstrap;

sub create-tasks-archive ($sparrowfile,%args?) is export {

  say "[utils] create task archive" if %args<verbose>;

  my @tar-cmd = (
    'tar',
    '-cf',
    "tasks.tar",
    $sparrowfile
  );

  run @tar-cmd;

  say "[utils] add $sparrowfile to archive OK" if %args<verbose>;

}

sub generate-bootstrap-script (%args?) is export {

  say "[utils] generat bootstrap script: /tmp/bootstrap.sh" if %args<verbose>;

  my $fh = open "/tmp/bootstrap.sh", :w;
  $fh.say(bootstrap-script());
  $fh.close;

  return "/tmp/bootstrap.sh";

}
