#! /usr/bin/env sh

main()
{
	readonly target=$(printf "%s" "$1" | awk -F: '{ print $1 }')

	# Deduce the image to use
	case "$target" in
		archlinux) image=base/archlinux         ;;
		amazon)    image=amazonlinux            ;;
		debian)    image=bitnami/minideb-extras ;;
		funtoo)    image=mastersrp/funtoo       ;;
		*)         image=$1
	esac

	# Create the docker instance
	docker run -t -d --name "$target" "$image" sh

	# Run bootstrap test
	sparrowdo --docker="$target" --no_sudo --bootstrap --task_run=bash@command=uname
}
