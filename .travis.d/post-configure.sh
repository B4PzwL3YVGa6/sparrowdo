set -e

distro=$1;

case "$distro" in
  centos) docker exec -i $distro  yum -q -y install perl-JSON-PP ;;
esac

