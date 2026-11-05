#!/usr/bin/env bash 

declare -a CURRENT=()
declare -a  PREVIOUS=()
declare -a ALL_CPUS=()

BAR_CHAR='|'
EMPTY_CHAR=' '
BAR_LENGTH=30

if [[ -z ${NO_COLOR:-} ]]; then 
	COLOR1=$'\e[31m' 
	COLOR2=$'\e[35m'
	COLOR3=$'\e[36m'
	DIM=$'\e[2m'
	RST=$'\e[0m'
else 
	COLOR1=''
	COLOR2=''
	COLOR3=''
	DIM=''
	RST=''

fi 

copy-data() {
	PREVIOUS=()

	local key  
	for key in "${!current[@]}"; do
		PREVIOUS[key]=${CURRENT[$key]} 
	done
}
read-all-cpus(){
	ALL_CPUS=()

	local path 

	for path in /sys/devices/system/cpu/cpu[0-9]*; do
		[[ -d $path ]] || continue 

		ALL_CPUS+=("${PATH##*/cpu}")
	done 
}
read-proc() {
	CURRENT=()
	
	local key user nice system idle iowait 
	local irq softirq steal guest guest_nice

	local busy value num

	for key in "${All_CPUS[@]}"; do 
		CURRENT[$key]=''
	done 

	while read -r key user nice system idle iowait \
		irq softirq steal guest guest_nice; do
			[[ $key == cpu* ]] || continue 

			[[ $key == cpu ]] && continue 

			num=${key#cpu}

			busy=$((user + nice + system + irq + softirq + steal + guest))
			idle=$((idle +iowait))
			
			value="$busy $idle"

			CURRENT[$num]=$value

		done < /proc/stat
}

print-bar(){

	local key=$1

	local busy1 idle1 busy2 idle2
	read -r busy1 idle1 <<< "${PREVIOUS[$key]:-}"
	read -r busy2 idle2 <<< "${CURRENT[$key]:-}"

	local usage online
	if [[ -z $busy1 || -z $busy2 ]]; then

		usage=0
		online=
	else

		local busy=$((busy2 - busy1))
		local idle=$((idle2 - idle1))
		local total=$((busy + idle))
		
		if (( total <= 0 )); then 
			usage=0
		else 
			usage=$((1000 * busy / total))
		fi 
	online=1
	fi

	local int=$((usage / 10))
	local frac=$((usage % 10))
	local perc=$int.$frac

	local num_bars=$((usage * BAR_LENGTH / 1000))

	local i
	local s='['
	for ((i = 0; i < num_bars; i++)); do
		s+="${COLOR1}${BAR_CHAR}${RST}"
	done

	for ((i = num_bars; i < BAR_LENGTH; i++)); do
		s+="$EMPTY_CHAR"
	done

	s+=']'	
	
	local state

	if [[ -n $online ]]; then
		printf -v perc '%-7s' "$perc%"
		state="${COLOR3}${perc}${RST}"
	else
		state="${DIM}offline${RST}"
	fi


	printf '%s %s%s%s %s\n' \
		"$s" "$COLOR2" "cpu$key" "$RST" "$state"
}	


visualize-data() {
	printf '%bCPU Usage on %b%s%b\n' \
		"$DIM" "$COLOR3" "$HOSTNAME" "$RST"

	local key 
	for key in "${!CURRENT[@]}"; do 
		print-bar "$key"
	done
	
	local now 
	printf -v now '%(%Y-%m-%dT%H:%M:%S%z)T'
	
	printf '%b%s%b\n' "$DIM" "$now" "$RST"
}

cleanup(){
	printf '\e[?1049l'
	printf '\e[?25h'	
}

update-window-size(){
	COLUMNS=${COLUMMS:-80}
	
	local cpus=( "${!CURRENT[@]}" )
	local highest_cpu=${cpus[-1]:-0}

	local i=$((2 + 4 + ${#highest_cpu} + 8))
	BAR_LENGTH=$((COLUMNS - i))

	(( BAR_LENGTH < 1)) && BAR_LENGTH=1

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

	while true; do
		copy-data
		read-proc
		
		printf '\e[H\[2J'

		visualize-data
		
		sleep 1
	done 
}
main "$@"
