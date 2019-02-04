use v6;

unit module Sparrowdo::Utils;

sub create-tasks-archive () is export {

  my @tar-cmd = (
    'tar',
    '-cf',
    "tasks.tar",
    "sparrowfile"
  );

  run @tar-cmd;

}
