case "$OS" in
  alpine)
    apk update --wait 120
    apk add --wait 120 curl perl-json bash git
  ;;
  amazon|centos|red)
    yum -q -y install make curl perl-JSON bash redhat-lsb-core git
    rm -rf /etc/yum.repos.d/rakudo-pkg.repo
    echo -e "[rakudo-pkg]\nname=rakudo-pkg\nbaseurl=https://dl.bintray.com/nxadm/rakudo-pkg-rpms/`lsb_release -is`/`lsb_release -rs| cut -d. -f1`/x86_64\ngpgcheck=0\nenabled=1" | tee -a /etc/yum.repos.d/rakudo-pkg.repo
    yum -q -y install rakudo-pkg
  ;;
  arch|archlinux)
    pacman -Syy
    pacman -S --needed --noconfirm -q curl perl-json bash git
    pacman -S --needed --noconfirm -q rakudo
  ;;
  debian|ubuntu)
    DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y -qq build-essential curl libjson-perl bash git lsb-release
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61
    rm -rf /etc/apt/sources.list.d/rakudo-pkg.list
    echo "deb https://dl.bintray.com/nxadm/rakudo-pkg-debs `lsb_release -cs` main" | tee -a /etc/apt/sources.list.d/rakudo-pkg.list
    apt-get update -qq && apt-get install -y -qq rakudo-pkg
  ;;
  fedora)
    dnf -yq install curl perl-JSON bash redhat-lsb-core git
    rm -rf /etc/yum.repos.d/rakudo-pkg.repo
    echo -e "[rakudo-pkg]\nname=rakudo-pkg\nbaseurl=https://dl.bintray.com/nxadm/rakudo-pkg-rpms/`lsb_release -is`/`lsb_release -rs| cut -d. -f1`/x86_64\ngpgcheck=0\nenabled=1" | tee -a /etc/yum.repos.d/rakudo-pkg.repo
    dnf -yq install rakudo-pkg
  ;;
  *)
    printf "Your OS (%s) is not supported\n" "$OS"
    exit 1
esac

zef install --/test --force-install https://github.com/melezhik/Sparrow6.git


