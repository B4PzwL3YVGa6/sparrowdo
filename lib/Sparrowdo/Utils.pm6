use v6;

unit module Sparrowdo::Utils;

sub create-tasks-archive (%args?) is export {

  say "[utils] create task archive" if %args<verbose>;

  my @tar-cmd = (
    'tar',
    '-cf',
    "tasks.tar",
    "sparrowfile"
  );

  run @tar-cmd;

}
