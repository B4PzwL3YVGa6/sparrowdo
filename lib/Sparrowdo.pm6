use v6;

unit module Sparrowdo;

sub task_run(%args) is export { 

  say 'running task <' ~ %args<task> ~ '> plg <' ~ %args<plugin> ~ '> ';
  say 'parameters: ' ~ %args<parameters>

}
 
