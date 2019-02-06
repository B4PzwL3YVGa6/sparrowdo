use v6;

unit module Sparrowdo::Ssh;

sub prepare-ssh-host ($host,%args?) is export {

  say "[ssh] prepare host: $host" if %args<verbose>;

  my @prepare-host-cmd = (
    "ssh",
    "-q",
    "-o",
    "ConnectionAttempts=1",
    "-o",
    "ConnectTimeout=5",
    "-o",
    "UserKnownHostsFile=/dev/null",
    "-o",
    "StrictHostKeyChecking=no",
    "-tt",
    "$host",
    "mkdir -p ~/.sparrowdo"
  );

  run @prepare-host-cmd;

}


sub copy-tasks-ssh-host ($host,%args?) is export {

  say "[ssh] copy tasks" if %args<verbose>;

  my @scp-cmd = (
    "scp",
    "-q",
    "-o",
    "ConnectionAttempts=1",
    "-o",
    "ConnectTimeout=5",
    "-o",
    "UserKnownHostsFile=/dev/null",
    "-o",
    "StrictHostKeyChecking=no",
    "tasks.tar",
    "$host:~/sparrowdo",
  );

  run @scp-cmd;

}


sub unpack-tasks-ssh-host ($host,%args?) is export {

  say "[ssh] unpack tasks" if %args<verbose>;

  my @unpack-tasks-cmd = (
    "ssh",
    "-q",
    "-o",
    "ConnectionAttempts=1",
    "-o",
    "ConnectTimeout=5",
    "-o",
    "UserKnownHostsFile=/dev/null",
    "-o",
    "StrictHostKeyChecking=no",
    "-tt",
    "$host",
    "tar -xf ~/.sparrowdo/tasks.tar -C ~/.sparrowdo/"
  );

  run @unpack-tasks-cmd;

}

sub run-tasks-ssh-host ($host,$sparrowfile,%args?) is export {

  say "[ssh] run tasks from $sparrowfile on host $host" if %args<verbose>;

  my @ssh-cmd = (
    "ssh",
    "-q",
    "-o",
    "ConnectionAttempts=1",
    "-o",
    "ConnectTimeout=5",
    "-o",
    "UserKnownHostsFile=/dev/null",
    "-o",
    "StrictHostKeyChecking=no",
    "-tt",
    "$host",
    "cd  ~/.sparrowdo/ && perl6 -MSparrow6::DSL $sparrowfile"
  );

  run @ssh-cmd;

}
