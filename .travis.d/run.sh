set -e

distro=$1;

PATH=/usr/local/bin:/opt/rakudo-pkg/bin/:~/.perl6/bin:$PATH

if test $distro =  "ubuntu"; then

    sparrowdo --docker=$distro --verbose --sparrowfile=examples/hello-world.pl6
    sparrowdo --docker=$distro --verbose --sparrowfile=examples/asserts/sparrowfile
    sparrowdo --docker=$distro --verbose --sparrowfile=examples/asserts-http-ok/sparrowfile
    sparrowdo --docker=$distro --verbose --sparrowfile=examples/bash/sparrowfile

else

    sparrowdo --docker=$distro --verbose --sparrowfile=examples/hello-world.pl6

fi


