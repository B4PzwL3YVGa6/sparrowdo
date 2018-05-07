#! /usr/bin/env sh

main()
{

	# Create the docker instance
  docker run --privileged --name debian --entrypoint  init -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d bitnami/minideb-extras

  cd ../ && strun --root examples/ --param flavor=travis

}

main "$@"
