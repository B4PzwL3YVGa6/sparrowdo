#! /usr/bin/env sh

main()
{

	# Create the docker instance
  docker run --privileged --name centos --entrypoint  init -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d centos

  export flavor_test=travis

  cd ../ && strun --root examples/

}

main "$@"
