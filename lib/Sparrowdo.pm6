use v6;

unit module Sparrowdo;

use Terminal::ANSIColor;

sub set_spl(%args) is export { 

  for %args.kv -> $plg, $source {

    @Sparrowdo::SPL.push: ($plg ~ ' ' ~ $source);

    say colored($plg ~ ' from ' ~ $source ~ ' pushed into SPL' , 'bold black on_yellow') if $Sparrowdo::Verbose;

  }

}

sub task_run(%args) is export { 

  my %task_data = %( 
      task => %args<task>,
      plugin => %args<plugin>,
      data => %args<parameters>
  );

  @Sparrowdo::Tasks.push: %task_data;

  say colored('compiled task <' ~ %args<task> ~ '> plg <' ~ %args<plugin> ~ '> OK', 'bold green on_blue');

}
 

