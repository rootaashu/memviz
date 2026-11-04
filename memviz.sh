#!/usr/bin/env bash 

declare  current=()
declare  previous=()

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

	local busy value num  
	while read -r key user nice system idle iowait \
		irq softirq steal guest guest_nice; do
			if [[ $key != cpu* ]]; then
				continue
			elif [[ $key == 'cpu' ]];then 
			continue 	
			fi 
			num=${key#cpu}

			busy=$((user + nice + system + irq + softirq + steal + guest))
			idle=$((idle +iowait))
			
			value="$busy $idle"

			current[$num]=$value

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
	
#visuals
	local bar_char='|'
	local empty_char=' '
	local length=50 
	
	local num_bars=$((usage * length / 1000))

	local i 
	local s='['
	for ((i=0; i<num_bars; i++)); do 
		s+=$bar_char 
	done 
	for ((i= num_bars; i<length; i++)); do 
		s+=$empty_char 
	done 
	s+=']'
	
	echo  "$s cpu$key $prec%"

}

visualize-data() {
	echo "${DIM}CPU Usage on $COLOR3$HOSTNAME$RST"

	local key 
	for key in "${!current[@]}"; do 
		print-bar "$key"
	done
	
	local now 
	printf -v now '%(%Y-%m-%dT%H:%M:%S%z)T'
	echo "$DIM$now$RST"
	
}

cleanup(){
	printf '\e[?1049h'
	printf '\e[?25l'	
}

update-window-size(){
	COLUMNS=${COLUMMS:-80}
	
	local cpus=( "${!CURRENT[@]}" )
	local highest_cpu=${cpus[-1]}

	local i=$((2+ 4 + ${#highest_cpu} + 8))
		BAR_LENGTH=$((COLUMNS - i))

}

read-all-cpus(){
	ALL_CPUS=(/sys/devices/system/cpu/cpu[0-16]*)
	ALL_CPUS=("${ALL_CPUS[@]##*/cpu}")

}	
main(){
	shopt -s checkwinsize 

	read-all-cpus
	read-proc 
	echo "waiting for data..."
	sleep 1 
	
	trap cleanup EXIT
	trap update-window-size WINCH 

	printf '\e[?1049h'
	printf '\e[?25l'
	printf '\e[H'

	update-window-size 

	local s
	while true; do
		copy-data
		read-proc

		printf'\e[H'
		visualize-data
		sleep 1
	done 
}
main "$@"
