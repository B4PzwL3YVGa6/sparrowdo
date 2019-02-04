use v6;

unit module Sparrowdo:ver<0.1.0>;

sub plg-run(@plg-list) is export {

  for @plg-list -> $p {
    if $p ~~ /(\S+)\@(.*)/ {
      my $name = $0; my $params = $1;
      my @args = split(/\,/,$params);
      #@plugins.push: [ $name,  @args ];
      #unless input_params('QuietMode') {
      #  term-out('push [plugin] ' ~ $name ~  ~ ' ' ~ @args ~ ' OK', input_params('NoColor'), %( colors => 'bold green on_black' ));
      #}
    } else {
      #@plugins.push: [ $p ];
      #unless input_params('QuietMode') {
      #  term-out('push [plugin] ' ~ $p ~  ' OK', input_params('NoColor'), %( colors => 'bold green on_black' ));
      #}
    }
  }
}

sub module_run($name, %args = %()) is export {

  #unless input_params('QuietMode') {
    #term-out('enter module <' ~ $name ~ '> ... ', input_params('NoColor'), %( colors => 'bold cyan on_black' ));
  #}

  if ( $name ~~ /(\S+)\@(.*)/ ) {
      my $mod-name = $0; my $params = $1;
      my %mod-args;
      for split(/\,/,$params) -> $p { %mod-args{$0.Str} = $1.Str if $p ~~ /(\S+?)\=(.*)/ };
      #require ::('Sparrowdo::' ~ $mod-name); 
      #::('Sparrowdo::' ~ $mod-name ~ '::&tasks')(%mod-args);
  } else {
      #require ::('Sparrowdo::' ~ $name); 
      #::('Sparrowdo::' ~ $name ~ '::&tasks')(%args);
  }

}


