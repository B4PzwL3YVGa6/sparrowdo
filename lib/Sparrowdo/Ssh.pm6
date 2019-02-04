use v6;

unit module Sparrowdo::Ssh;

sub prepare-ssh-host ($host) is export {

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


sub copy-tasks-ssh-host ($host) is export {

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
