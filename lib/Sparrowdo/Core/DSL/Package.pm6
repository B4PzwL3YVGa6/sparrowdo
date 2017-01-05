use v6;

unit module Sparrowdo::Core::DSL::Package;

use Sparrowdo;

sub package-install ( @list ) is export {

    task_run  %(
      task => "install packages: " ~ (join ' ', @list),
      plugin => 'package-generic',
      parameters => %(
        list        => (join ' ', @list),
        action      => 'install',
      )
    );

}

constant &package = &package-install; # just an alias for the sake of being terse
