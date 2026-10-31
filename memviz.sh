#!/usr/bin/env bash 


read-proc() {
	while read -r key foo bar baz line; do
		echo "$key"
		echo "$foo"


	done < /proc/stat
}

read-proc
