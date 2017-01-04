use v6;

unit module Sparrowdo::Core::DSL;
use Sparrowdo;

sub user-create ( $label, %params ) is export {

    task_run  %(
      task => $label,
      plugin => 'user',
      parameters => %(
        name        => %params<name>,
        action      => 'create',
      )
    );

}

sub user-delete ( $label, %params ) is export {

    task_run  %(
      task => $label,
      plugin => 'user',
      parameters => %(
        name        => %params<name>,
        action      => 'delete',
      )
    );

}

sub package-install ( @list ) is export {

    task_run  %(
      task => "install @list",
      plugin => 'package-generic',
      parameters => %(
        list        => (join ',', @list),
        action      => 'install',
      )
    );

}
