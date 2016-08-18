use v6;

unit module Sparrowdo;

use Terminal::ANSIColor;

my %input_params = Hash.new;
my $target_os;

sub set_target_os ($os) is export  {
  $target_os = $os
}

sub target_os () is export  {
  return $target_os;
}

sub set_input_params (%args) is export  {

  for %args.kv -> $name, $value {
    %input_params.push($name => $value);
  }

}

sub input_params ($name) is export  {

  %input_params{$name};

}

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

