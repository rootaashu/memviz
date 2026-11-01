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
	local key user nice system idle iowait 
	local irq softirq steal guest guest_nice

	local busy value 
	while read -r key user nice system idle iowait \
		irq softirq steal guest guest_nice; do
			if [[ $key != cpu* ]]; then
				continue
			elif [[ $key == 'cpu' ]];then 
			continue 	
			fi 

			busy=$((user + nice + system + irq + softirq + steal + guest))
			idle=$((idle +iowait))
			
			value="$busy $idle"

			current[$key]=$value

		done < /proc/stat
}

print-bar(){
	local key=$1

	local busy1 idle1 busy2 idle2
	read -r busy1 idle1 <<< "${previous[$key]}"
	read -r busy2 idle2 <<< "${current[$key]}"
	
	local busy=$((busy2 - busy1))
	local idle=$((idle2 - idle1))
	local total=$((busy + idle))
	
		local usage=$((1000 * busy / total))
		local int==$((usage / 10))
		local frac=$((usage % 10))
		local prec=$int.$frac
		echo "$key is $prec% busy"


}

visualize-data() {
	local key 
	for key in "${!current[@]}"; do 
		print-bar "$key"
	done
	echo
	
}

main(){
	read-proc
	sleep 1 
	echo "waiting for data..."
	while true; do
	copy-data
	read-proc
	visualize-data
	sleep 1
	done 
}
main "$@"
