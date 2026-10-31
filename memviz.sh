#!/usr/bin/env bash 


read-proc() {
	local key user nice system idle lowait 
	local irq softirq steal guest guest_nice
	while read -r key user nice system idle lowait \
		irq softirq steal guest guest_nice; do
			if [[ $key != cpu* ]]; then
				continue 
			fi 
			echo "$key user =$user"

		done < /proc/stat
}

read-proc
