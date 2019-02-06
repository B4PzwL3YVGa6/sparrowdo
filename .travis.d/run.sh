set -e

distro=$1;

PATH=/usr/local/bin:/opt/rakudo-pkg/bin/:/home/travis/.perl6/bin:$PATH

case "$distro" in
  ubuntu)
    sparrowdo --docker=$distro --verbose --sparrowfile=examples/hello-world.pl6
    sparrowdo --docker=$distro --verbose --sparrowfile=examples/asserts/sparrowfile
  ;;
    sparrowdo --docker=$distro --verbose --sparrowfile=examples/hello-world.pl6
  *)

esac


