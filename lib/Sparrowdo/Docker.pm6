use v6;

unit module Sparrowdo::Docker;

sub prepare-docker-host ($host,%args?) is export {

  say "[docker] prepare instance: $host" if %args<verbose>;

  my @prepare-cmd = (
    "docker",
    "exec",
    "-i",
    "$host",
    "mkdir -p ~/.sparrowdo"
  );

  run @prepare-cmd;

}


sub copy-tasks-docker-host ($host,%args?) is export {

  say "[docker] copy tasks" if %args<verbose>;

  my @cp-cmd = (
    "docker",
    "cp",
    "tasks.tar",
    "$host:~/sparrowdo",
  );

  run @cp-cmd;

}


sub unpack-tasks-docker-host ($host,%args?) is export {

  say "[docker] unpack tasks" if %args<verbose>;

  my @unpack-tasks-cmd = (
    "docker",
    "exec",
    "-i",
    "$host",
    "tar -xf ~/.sparrowdo/tasks.tar -C ~/.sparrowdo/"
  );

  run @unpack-tasks-cmd;

}

sub run-tasks-docker-host ($host,%args?) is export {

  say "[docker] run tasks" if %args<verbose>;

  my @cmd = (
    "docker",
    "exec",
    "-i",
    "$host",
    "cd  ~/.sparrowdo/ && perl6 -MSparrow6::DSL sparrowfile"
  );

  run @cmd;

}
