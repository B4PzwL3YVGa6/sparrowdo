#! /usr/bin/env sh

main()
{

	# Create the docker instance
  docker run --privileged --name centos --entrypoint  init -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d openshift/base-centos7

  cd ../ && strun --root examples/ --param flavor=travis

}

main "$@"
