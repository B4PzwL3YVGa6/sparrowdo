set -e

distro=$1;

PATH=/usr/local/bin:/opt/rakudo-pkg/bin/:~/.perl6/bin:$PATH

sparrowdo --docker=$distro --verbose --bootstrap
