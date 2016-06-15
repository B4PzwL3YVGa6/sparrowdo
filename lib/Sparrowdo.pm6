use v6;

unit module Sparrowdo;

use Terminal::ANSIColor;
use JSON::Tiny;

sub task_run(%args) is export { 

  say colored('running task <' ~ %args<task> ~ '> plg <' ~ %args<plugin> ~ '> ', 'bold green on_blue');

  say 'parameters:';

  say %args<parameters>;

  shell 'sudo sparrow index update';

  shell 'sudo sparrow plg install ' ~ %args<plugin>;

  shell 'sudo sparrow project create sparrowdo';

  my $sparrow_task = %args<task>.subst(/\s+/,'_', :g);

  shell 'sudo sparrow task add sparrowdo ' ~ $sparrow_task ~ ' ' ~ %args<plugin> ;

  my $filename = '/tmp/' ~ $sparrow_task ~ '.json';
  
  my $fh = open $filename, :w;

  $fh.say(to-json %args<parameters>);

  $fh.close;
    
  shell 'sudo sparrow task run sparrowdo ' ~ $sparrow_task ~ ' --json ' ~ $filename


}
 

