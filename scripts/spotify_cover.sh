#!/usr/bin/sh

playerctl -F metadata mpris:artUrl | while read -r metadata ; do
    if [ ! -z "$metadata" ]; then
	case "$metadata" in
	file*)
		cp "$(echo "$metadata" | sed "s/^file:\/\///")" "/tmp/cover.jpeg";;
	http*)
	        curl -s "$metadata" --output "/tmp/cover.jpeg";;
	*)
		rm "/tmp/cover.jpeg";;
	esac
    fi
done
