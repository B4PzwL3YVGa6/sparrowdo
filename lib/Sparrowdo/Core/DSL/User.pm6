use v6;

unit module Sparrowdo::Core::DSL::User;

use Sparrowdo;

sub user-create ( $user_id ) is export {

    task_run  %(
      task => "create user $user_id",
      plugin => 'user',
      parameters => %(
        name        => $user_id,
        action      => 'create',
      )
    );

}

sub user-delete ( $user_id ) is export {

    task_run  %(
      task => "delete user $user_id",
      plugin => 'user',
      parameters => %(
        name        => $user_id,
        action      => 'delete',
      )
    );

}

