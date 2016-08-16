use v6;

unit module Sparrowdo;

use Terminal::ANSIColor;

sub set_spl(%args) is export { 
  for %args.kv -> $plg, $source {
    @Sparrowdo::SPL.push: ($plg ~ ' ' ~ $source);
  }
}

sub task_run(%args) is export { 

  my %task_data = %( 
      task => %args<task>,
      plugin => %args<plugin>,
      data => %args<parameters>
  );

  @Sparrowdo::Tasks.push: %task_data;

  say colored('push task <' ~ %args<task> ~ '> plg <' ~ %args<plugin> ~ '> OK', 'bold green on_blue');

}
 

sub module_run($name, %args = %()) is export {

  say colored('module run <' ~ $name ~ '> args <' ~ %args ~ '>', 'bold cyan on_blue');

  require ::('Sparrowdo::' ~ $name); 
  ::('Sparrowdo::' ~ $name ~ '::&tasks')(%args);


}
