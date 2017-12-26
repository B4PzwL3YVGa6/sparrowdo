use v6;

unit module Sparrowdo::Core::DSL::Git;

use Sparrowdo;

use Sparrowdo::Core::DSL::Bash;


multi sub git-scm ( $source, %args? ) is export {

  my $cd-cmd = %args<to> ?? "cd " ~ %args<to> ~ ' && pwd ' !! 'pwd';
  my %bash-args = Hash.new;
  %bash-args<description> = "fetch from git source: $source";
  %bash-args<user> = %args<user> if %args<user>;
  %bash-args<debug> = 1 if %args<debug>;

  my $git-clone-cmd;
  if %args<branch> {
    $git-clone-cmd = "git -b " ~ %args<branch> ~ " clone $source ."
  } else {
    $git-clone-cmd = "git clone $source ."
  }

  bash qq:to/HERE/, %bash-args;
    set -e;
    $cd-cmd
    if test -d .git; then
      git pull
    else
      $git-clone-cmd
    fi
  HERE

}


