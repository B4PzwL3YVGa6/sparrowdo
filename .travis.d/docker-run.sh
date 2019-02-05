set -e

distro=$1;

case "$distro" in
  archlinux) image=base/archlinux         ;;
  alpine)    image=jjmerelo/alpine-perl6  ;;
  *)         image=$distro
esac

docker run --name $distro -td --entrypoint sh $image
