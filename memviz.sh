#!/usr/bin/env bash 


read-proc() {
	while read -r line; do
		echo "$line"


	done < /proc/stat
}

read-proc
