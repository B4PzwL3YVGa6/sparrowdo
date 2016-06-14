use v6;

unit module Sparrowdo;

use Terminal::ANSIColor;

sub task_run(%args) is export { 

  say colored('running task <' ~ %args<task> ~ '> plg <' ~ %args<plugin> ~ '> ', 'bold green on_blue');
  say 'parameters:';
  say %args<parameters>;

}
 
