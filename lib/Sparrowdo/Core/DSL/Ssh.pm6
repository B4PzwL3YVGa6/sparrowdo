use v6;

unit module Sparrowdo::Core::DSL::Ssh;

use Sparrowdo;
use Sparrowdo::Core::DSL::Bash;
use Sparrowdo::Core::DSL::Directory;
use Sparrowdo::Core::DSL::File;

sub ssh ( $command, %args? ) is export { 

  my %ssh-command;

  directory '/opt/sparrow/.cache/';

  if %args<ssh-key>:exists {
    file '/opt/sparrow/.cache/ssh-key', %( 
      content => ( slurp %args<ssh-key> ),
      mode => '0600'
    );
  }

  my $ssh-host-term = %args<user>:exists ?? %args<user> ~ '@' ~ %args<host> !! %args<host>;


  my $ssh-run-cmd  =  'ssh -o ConnectionAttempts=1  -o ConnectTimeout=5';

  $ssh-run-cmd ~= ' -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -tt';

  $ssh-run-cmd ~= ' -q' ;

  $ssh-run-cmd ~= ' -i /opt/sparrow/.cache/ssh-key' if %args<ssh-key>:exists;

  $ssh-run-cmd ~= " $ssh-host-term '$command'";

  my $bash-cmd;

  if %args<create>:exists {
    $bash-cmd = "if ! test -f %args<create> ; then set -x; $ssh-run-cmd ; else echo skip due to %args<create> exists; fi"    
  } else {
    $bash-cmd = "set -x; $ssh-run-cmd"
  }

  bash $bash-cmd, %(
    description => "ssh command on $ssh-host-term",
    debug       => %args<debug>:exists ?? 1 !! 0,
  );

  file-delete '/opt/sparrow/.cache/ssh-key' if %args<ssh-key>:exists;

  file %args<create> if %args<create>:exists;

}
