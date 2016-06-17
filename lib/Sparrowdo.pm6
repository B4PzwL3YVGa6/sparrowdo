use v6;

unit module Sparrowdo;

use Terminal::ANSIColor;

use JSON::Tiny;

my $cleanup_state =  False;
my $index_update =  False;

sub task_run(%args) is export { 

  say colored('running task <' ~ %args<task> ~ '> plg <' ~ %args<plugin> ~ '> ', 'bold green on_blue');

  say 'parameters:';

  say %args<parameters>;

  if $index_update == False and ! $Sparrowdo::SkipIndexUpdate  {
    ssh_shell 'sparrow index update';
    $index_update = True;
  }


  if $cleanup_state == False  {
    ssh_shell 'sparrow project remove sparrowdo';
    $cleanup_state = True;
  }

  ssh_shell 'sparrow plg install ' ~ %args<plugin>;

  ssh_shell 'sparrow project create sparrowdo';

  my $sparrow_task = %args<task>.subst(/\s+/,'_', :g);

  ssh_shell  'sparrow task add sparrowdo ' ~ $sparrow_task ~ ' ' ~ %args<plugin>;

  my $filename = '/tmp/' ~ $sparrow_task ~ '.json';
  
  my $fh = open $filename, :w;

  $fh.say(to-json %args<parameters>);

  $fh.close;

  scp $filename;

  ssh_shell 'sparrow task run sparrowdo ' ~ $sparrow_task ~ ' --json ' ~ $filename;


}
 

sub ssh_shell ( $cmd ) {


  my @bash_commands = ( 'export LC_ALL=en_US.UTF-8' );

  @bash_commands.push:  'export http_proxy=' ~ $Sparrowdo::HttpProxy if $Sparrowdo::HttpProxy;
  @bash_commands.push:  'export https_proxy=' ~ $Sparrowdo::HttpsProxy if $Sparrowdo::HttpsProxy;
  @bash_commands.push:  $cmd;

  my $ssh_host_term = $Sparrowdo::Host;

  $ssh_host_term = $Sparrowdo::SshUser ~ '@' ~ $ssh_host_term if $Sparrowdo::SshUser;

  my $ssh_cmd = 'ssh -q -tt -p ' ~ $Sparrowdo::SshPort ~ ' ' ~ $ssh_host_term ~ " ' sudo bash -c \"" ~ ( join ' ; ', @bash_commands ) ~ "\"'";
  
  say colored($ssh_cmd, 'bold green') if $Sparrowdo::Verbose;

  shell $ssh_cmd;
}

sub scp ( $file ) {

  my $ssh_host_term = $Sparrowdo::Host;

  $ssh_host_term = $Sparrowdo::SshUser ~ '@' ~ $ssh_host_term if $Sparrowdo::SshUser;
  
  shell 'scp -P ' ~ $Sparrowdo::SshPort ~ ' ' ~ $file ~ ' ' ~ $ssh_host_term ~ ':/tmp/';

}

