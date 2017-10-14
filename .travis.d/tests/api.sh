#! /usr/bin/env sh

main()
{

  readonly target=$(printf "%s" "$1" | awk -F: '{ print $2 }')

	# Create the docker instance
  docker run --privileged --name centos --entrypoint  init -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d centos

	# Run api test
	sparrowdo --docker=centos --no_sudo --bootstrap --sparrowfile=examples/$target/sparrowfile
}

main "$@"
