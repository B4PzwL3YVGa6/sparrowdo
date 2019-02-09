set -e

export SP6_REPO=http://sparrow6.southcentralus.cloudapp.azure.com

distro=$1

sparrowfile=$2

config=$3

PATH=/usr/local/bin:/opt/rakudo-pkg/bin/:~/.perl6/bin:$PATH

if test -z $config; then
  sparrowdo --docker=$distro --verbose --sparrowfile=$sparrowfile
else
  sparrowdo --docker=$distro --verbose --sparrowfile=$sparrowfile --conf=$config
fi


