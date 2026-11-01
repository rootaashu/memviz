#!/usr/bin/env bash 

declare -A current=()
declare -A previous=()

copy-data() {
	previous=()

	local key value 
	for key in "${!current[@]}"; do
		value=${current[$key]}
		previous[key]=$value 
	done
}

read-proc() {
	local key user nice system idle lowait 
	local irq softirq steal guest guest_nice

	local busy value 
	while read -r key user nice system idle lowait \
		irq softirq steal guest guest_nice; do
			if [[ $key != cpu* ]]; then
				continue 
			fi 

			busy=$((user + nice + system + irq + softirq + steal + guest + nice))
			idle=$((idle +lowait))
			
			value="$busy $idle"

			current[$key]=$value

		done < /proc/stat
}

read-proc
sleep 1 
copy-data
read-proc

echo "previous cpu statistics "
declare -p previous 

echo
echo "current cpu statistics"
declare -p current 

