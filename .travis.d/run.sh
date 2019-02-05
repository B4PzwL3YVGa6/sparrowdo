set -e

distro=$1;

PATH=/usr/local/bin:/opt/rakudo-pkg/bin/:/home/travis/.perl6/bin:$PATH

case "$distro" in
  archlinux) image=base/archlinux         ;;
  alpine)    image=jjmerelo/alpine-perl6  ;;
  *)         image=$distro
esac

docker run --name $distro -td --entrypoint sh  $image
mv sparrowfile sparrowfile.off
time sparrowdo --docker=$distro --verbose --bootstrap
mv sparrowfile.off sparrowfile
time sparrowdo --docker=$distro --verbose
time sparrowdo --docker=$distro --verbose

