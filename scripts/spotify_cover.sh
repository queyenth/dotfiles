#!/usr/bin/sh

playerctl -F metadata mpris:artUrl | while read -r metadata ; do
    if [ ! -z "$metadata" ]; then
	case "$metadata" in
	    file*)
		cp "$(echo "$metadata" | sed "s/^file:\/\///")" "/tmp/cover.jpeg"
                magick /tmp/cover.jpeg -colorspace Gray /tmp/cover.jpeg;;
	    http*)
	        curl -s "$metadata" --output "/tmp/cover.jpeg"
                magick /tmp/cover.jpeg -colorspace Gray /tmp/cover.jpeg;;
	    # *)
	    # 	rm "/tmp/cover.jpeg";;
	esac
        echo /tmp/cover.jpeg
    fi
done
