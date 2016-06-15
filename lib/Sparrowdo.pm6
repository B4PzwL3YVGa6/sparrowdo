use v6;

unit module Sparrowdo;

use Terminal::ANSIColor;

sub task_run(%args) is export { 

  say colored('running task <' ~ %args<task> ~ '> plg <' ~ %args<plugin> ~ '> ', 'bold green on_blue');

  say 'parameters:';

  say %args<parameters>;

  shell 'sparrow plg install ' ~ %args<plugin>;

  shell 'sparrow plg run ' ~ %args<plugin>;


}
 
# my %a = ("one" => 1, "two" => 2); say %a.keys.sort.map: {my $k = $_; "--params " ~ $k ~ "=" ~ %a<<$k>>} '
(--params one=1 --params two=2)

