use v6;

unit module Sparrowdo::Core::DSL::Bash;

use Sparrowdo;

multi sub bash ( $command ) is export { bash $command, %() };
multi sub bash ( $command, $user ) is export { bash $command, %( user => $user ) };


multi sub bash ( $command, %opts = () ) is export {

    my $task_name = %opts<description> || "execute bash command";

    my %params = Hash.new;

    %params<command> = $command;

    %params<user> = %opts<user> if %opts<user>:exists;
    %params<debug> = %opts<debug> if %opts<debug>:exists;
    %params<expect_stdout> = %opts<expect_stdout> if %opts<expect_stdout>:exists;

    task_run  %( task => $task_name, plugin => 'bash', parameters => %params );

}