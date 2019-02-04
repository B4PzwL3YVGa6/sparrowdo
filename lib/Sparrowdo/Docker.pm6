use v6;

unit module Sparrowdo::Docker;

use Sparrowdo::Bootstrap;

sub prepare-docker-host ($host,%args?) is export {

  say "[docker] prepare instance: $host" if %args<verbose>;

  my @prepare-cmd = (
    "docker",
    "exec",
    "-i",
    "$host",
    "mkdir", 
    "-p",
    "/var/.sparrowdo"
  );

  run @prepare-cmd;

  say "[docker] generated bootstrap script: /tmp/bootstrap.sh" if %args<verbose>;

  my $fh = open "/tmp/bootstrap.sh", :w;
  $fh.say(bootstrap-script());
  $fh.close;

  say "[docker] copy bootstrap script" if %args<verbose>;

  my @cp-cmd = (
    "docker",
    "cp",
    "/tmp/bootstrap.sh",
    "$host:/var/.sparrowdo",
  );

  run @cp-cmd;

}


sub copy-tasks-docker-host ($host,%args?) is export {

  say "[docker] copy tasks" if %args<verbose>;

  my @cp-cmd = (
    "docker",
    "cp",
    "tasks.tar",
    "$host:/var/.sparrowdo",
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
    "tar",
    "-xf",
    "/var/.sparrowdo/tasks.tar",
    "-C", 
    "/var/.sparrowdo/"
  );

  run @unpack-tasks-cmd;

}

sub run-tasks-docker-host ($host,%args?) is export {

  say "[docker] run tasks" if %args<verbose>;

  my $cmd = "docker exec -e SP6_REPO=http://sparrow6.southcentralus.cloudapp.azure.com";
  $cmd ~= " -e SP6_DEBUG=1" if %args<debug>;
  $cmd ~= " -i $host sh -c 'cd  /var/.sparrowdo/ && perl6 -MSparrow6::Repository";
  $cmd ~= " -e \"Sparrow6::Repository::Api.new.index-update\" && perl6 -MSparrow6::DSL sparrowfile'";

  shell $cmd;

}

sub bootstrap-docker-host ($host, %args?) is export {

  say "[docker] bootstrap" if %args<verbose>;

  my @cmd = (
    "docker",
    "exec",
    "-i",
    "$host",
    "sh", 
    "/var/.sparrowdo/bootstrap.sh"
  );

  run @cmd;

  @cmd = (
    "docker",
    "exec",
    "-i",
    "$host",
    "apk",
    "add",
    "perl-json",
    "bash",
    "curl"
  );

  run @cmd;

}
