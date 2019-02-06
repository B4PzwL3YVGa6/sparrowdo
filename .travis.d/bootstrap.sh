set -e

distro=$1;

PATH=/usr/local/bin:/opt/rakudo-pkg/bin/:/home/travis/.perl6/bin:$PATH

sparrowdo --docker=$distro --verbose --bootstrap
