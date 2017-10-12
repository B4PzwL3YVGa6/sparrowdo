#! /usr/bin/env sh

main()
{
	readonly target=$1

	# Extend the PATH
	export PATH=/opt/rakudo/bin/:~/.perl6/bin:$PATH

	# Deduce the image to use
	case "$target" in
		archlinux) image=base/archlinux         ;;
		amazon)    image=amazonlinux            ;;
		debian)    image=bitnami/minideb-extras ;;
		funtoo)    image=mastersrp/funtoo       ;;
		*)         image=$1
	esac

	# Create the docker instance
	docker run -t -d --name "$target" "$image" bash

	# Run bootstrap test
	sparrowdo --docker="$target" --no_sudo --bootstrap --task_run=bash@command=uptime
}

main "$@"
