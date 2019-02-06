set -e

distro=$1;

PATH=/usr/local/bin:/opt/rakudo-pkg/bin/:/home/travis/.perl6/bin:$PATH

mv sparrowfile.off sparrowfile

sparrowdo --docker=$distro --verbose --sparrowfile=examples/hello-world.pl6

