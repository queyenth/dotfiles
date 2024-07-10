#!/bin/sh

trim()
{
    local trimmed="$1"
    trimmed="${trimmed##\"}"
    trimmed="${trimmed%%\"}"
    echo $trimmed
}

result=$(emacsclient -e "$@")
trim "$result"
