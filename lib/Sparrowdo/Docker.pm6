use v6;

unit module Sparrowdo::Docker;

use Sparrowdo::Utils;

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

  my $path = generate-bootstrap-script(%args);

  say "[docker] copy bootstrap script" if %args<verbose>;

  my @cp-cmd = (
    "docker",
    "cp",
    $path,
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

sub run-tasks-docker-host ($host,$sparrowfile,%args?) is export {

  say "[docker] run tasks from $sparrowfile on instance $host" if %args<verbose>;

  my $cmd = "docker exec -e SP6_REPO=http://sparrow6.southcentralus.cloudapp.azure.com";
  $cmd ~= " -e SP6_DEBUG=1" if %args<debug>;
  $cmd ~= " -i $host sh -c '";
  $cmd ~= " cd  /var/.sparrowdo/ && export PATH=/opt/rakudo-pkg/bin:\$PATH && perl6 -MSparrow6::Repository";
  $cmd ~= " -e \"Sparrow6::Repository::Api.new.index-update\" && perl6 -MSparrow6::DSL $sparrowfile'";

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

}
