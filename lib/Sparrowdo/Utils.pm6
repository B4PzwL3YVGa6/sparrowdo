use v6;

unit module Sparrowdo::Utils;

use Sparrowdo::Bootstrap;

sub create-tasks-archive ($sparrowfile,%args?) is export {

  say "[utils] create task archive" if %args<verbose>;

  my @paths = ( $sparrowfile, "data", "files", "templates", "conf" ); 

  my @tar-cmd = (
    'tar',
    '-cf',
    "tasks.tar"
  );

  for @paths -> $p {
    next unless $p.IO ~~ :e;
    @tar-cmd.push($p);
    say "[utils] add $p to archive" if %args<verbose>;
  }

  say @tar-cmd;

  run @tar-cmd;

  say "[utils] task archive created" if %args<verbose>;

}

sub generate-bootstrap-script (%args?) is export {

  say "[utils] generat bootstrap script: /tmp/bootstrap.sh" if %args<verbose>;

  my $fh = open "/tmp/bootstrap.sh", :w;
  $fh.say(bootstrap-script());
  $fh.close;

  return "/tmp/bootstrap.sh";

}
