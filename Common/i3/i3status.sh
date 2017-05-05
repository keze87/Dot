#!/bin/sh

#imprimir $color $text $separatorwidth $ultimo $shorttext
imprimir() {

	echo -e "
	{
		\"color\":\"$1\","

	if [[ $3 == 0 ]]; then

		echo -e "
		\"separator\": false,
		\"separator_block_width\": $3,"

	fi

	if [[ $# == 5 ]]; then

		echo -e "
		\"full_text\":\"$2\",
		\"short_text\":\"$5\""

	else

		echo -e "		\"full_text\":\"$2\""

	fi

	if [[ $4 == 0 ]]; then

		echo '	},'

	else

		echo '	}
],'

	fi

}

echo -e '
{"version":1}
[
[
	{
		"color":"#000000",
		"full_text":"I"
	}
],'

if [[ -f ~/.dotlaptop ]]; then

	#desktop=false;
	laptop=true;

fi

if [[ ${laptop} ]]; then

	brillomax=$(cat /sys/class/backlight/intel_backlight/max_brightness)

fi

up=true
headphones=false
s="#FFFFFF"

while true; do

	player=""

	if playerctl status 2>&1 | grep -q Playing; then

		if playerctl -p spotify status | grep -q Playing; then

			player="spotify"

		else

			if playerctl -p audacious status | grep -q Playing; then

				player="audacious"

			fi

		fi

	fi

	if [[ ${player} ]]; then

		artist=$(playerctl -p ${player} metadata artist | tr '"' "'")

		album=$(playerctl -p ${player} metadata album | tr '"' "'")

		title=$(playerctl -p ${player} metadata title | tr '"' "'")

	fi

	if [[ -f ~/memo ]]; then

		memo=$(grep -v '#' < ~/memo | tr -s "\n" " ")

	fi

	if date +"%M:%S" | grep -q '0:0'; then

		tenmin=true

	else

		tenmin=false

	fi

	cpu=$(cat /sys/devices/platform/coretemp.0/hwmon/*/temp1_input | cut -c1-2)

	if [[ ${laptop} ]]; then

		brillo=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
		brillo=$(echo "$brillo * 100 / $brillomax" | bc -l)

		bateria1=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | \
		grep perce | awk '{print $2}' | tr -d '%')
		bateria2=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | \
		grep state | awk '{print $2}')

		wifi=$(iwgetid -r)

		if [[ ! ${wifi} ]]; then

			if ip link | grep -q enp0s20u; then

				wifi='USB'

			fi

		fi

		volumen=$(amixer get Master | grep Right: | awk '{print $5}' | tr -d "[]%");

		disco1=$(df | grep sdb3 | awk '{print $5}')
		disco2=$(df | grep sda3 | awk '{print $5}')

		fecha=$(date +"%A %d-%m %H:%M:%S")

	else # if desktop

		if [[ ${tenmin} == true || ! ${ip} ]]; then

			ip=$(ip r | grep default | cut -d ' ' -f 3)

		fi

		nvidia=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

		volumen=$(amixer get Master | grep "Front Right:" | awk '{print $5}' | tr -d "[]%")

		if ! amixer get Master | grep -q "Rear"; then

			headphones=true;

		else

			headphones=false;

		fi

		if [[ ${tenmin} == true || ! ${disco1} || ! ${disco2} ]]; then

			disco1=$(df | grep sdb1 | awk '{print $5}')
			disco2=$(df | grep sda1 | awk '{print $5}')

		fi

		fecha=$(date +"%A %d-%m-%Y %H:%M:%S")

	fi

	echo -e "["

	if [[ (${player} && ${title}) || ${headphones} == true ]]; then

		s=$(tail -n1 .config/i3/config | tr -d "\t")

	fi

	### Spotify ###

	if [[ ${player} && ${title} ]]; then

		if [[ ${player} == 'spotify' ]]; then

			text="  "

		else

			text="  "

		fi

		imprimir "${s}" "${text}" 0 0

		if [[ ${artist} ]]; then

			imprimir "#FFFFFF" " ${artist} " 0 0

		fi

		if [[ ( ${album} || ${title} ) && ${artist} ]]; then

			imprimir "${s}" "--" 0 0 ''

		fi

		if [[ ${album} ]]; then

			imprimir "#FFFFFF" " ${album} " 0 0 ''

		fi

		if [[ ${album} && ${title} ]]; then

			imprimir "${s}" "--" 0 0

		fi

		imprimir "#FFFFFF" " ${title} " 1 0

	fi

	### Internet ###

	if [[ ${laptop} ]]; then

		if [[ ${wifi} ]]; then

			if [[ ${wifi} == "USB" ]]; then

				internet=$(ip link | grep enp0s20u | awk '{print $2}' | tr -c -d '[:alnum:]')

			else

				internet="wlp2s0"

			fi

			if [[ ${internet} ]]; then

				speed=$(sh ~/.config/i3/speed.sh ${internet})

			fi

			if [[ $speed == "0 K↓ 0 K↑" ]]; then

				text="   ${wifi} "

			else

				text="   ${speed} (${wifi}) "

			fi

			imprimir "#FFFFFF" " ${text} " 1 0

			up=true
			upsonido=true

		else

			up=false

		fi

	else # desktop

		if ping -q -w 1 -c 1 "${ip}" > /dev/null; then

			speed=$(sh ~/.config/i3/speed.sh "eno1")

			if [[ "${speed}" != '0 K↓ 0 K↑' ]]; then

				imprimir "#FFFFFF" "   ${speed} " 1 0

			fi

			up=true
			upsonido=true

		else

			up=false

		fi

	fi

	if [[ ${up} == false ]]; then

		time=$(awk '{print $0/60;}' /proc/uptime)

		if [[ ${time%.*} -gt 1 ]]; then

			if [[ ${upsonido} == true ]]; then

				mpv --really-quiet /usr/share/sounds/freedesktop/stereo/dialog-information.oga

				upsonido=false

			fi

		fi

		imprimir "#FF0000" "   Sin Internet " 1 0

	fi

	### Brillo ###

	if [[ ${brillo} ]]; then

		if [ "${brillo%.*}" -lt "100" ]; then

			imprimir "#FFFFFF" "   ${brillo%.*} " 1 0

		fi

	fi

	### El Memo ###

	if [[ ${memo} ]]; then

		color=$(grep '#' < ~/memo | grep -v ':' | tr -c -d '[:alnum:]')

		if ! echo "${color}" | grep -q '^[0-9A-F]\{6\}$'; then

			color='FFFFFF'

		fi

		imprimir "#${color}" "   ${memo::-1} " 1 0 "   Memo "

		memo=""

	fi

	### Volumen ###

	if [[ ${headphones} == true ]]; then

		imprimir "${s}" "  " 0 0

		imprimir "#FFFFFF" " ${volumen}% " 1 0

	else

		if [ "${volumen}" -lt 10 ]; then

			text="   ${volumen}% "

		else

			if [[ "${volumen}" -lt 100 ]]; then

				text="   ${volumen}% "

			else

				text="   "

			fi

		fi

		imprimir "#FFFFFF" "${text}" 1 0

	fi

	### Root ###

	imprimir "#FFFFFF" "   ${disco1} " 1 0

	### Home ###

	imprimir "#FFFFFF" "   ${disco2} " 1 0

	### Nvidia ###

	if [[ ${nvidia} ]]; then

		if [[ ${nvidia} -lt 60 ]]; then

			color="#FFFFFF"

		else

			if [[ ${nvidia} -lt 80 ]]; then

				color="#FFA500"

			else

				color="#FF0000"

			fi

		fi

		imprimir "${color}" "   ${nvidia} °C " 1 0

	fi

	### CPU ###

	if [[ ${cpu} -lt 60 ]]; then

		color="#FFFFFF"

	else

		if [[ ${cpu} -lt 80 ]]; then

			color="#FFA500"

		else

			color="#FF0000"

		fi

	fi

	imprimir "${color}" "   ${cpu}°C " 1 0

	### Bateria ##

	if [[ ${bateria1} ]]; then

		if [ "${bateria1}" -gt 50 ]; then

			color="#FFFFFF"

		else

			if [[ "${bateria1}" -gt 20 ]]; then

				color="#FFA500"

			else

				color="#FF0000"

			fi

		fi

		if [ "${bateria2}" = "discharging" ]; then

			if [ "${bateria1}" -lt 30 ]; then

				text="   ${bateria1}% "

			else

				if [[ "${bateria1}" -lt 65 ]]; then

					text="   ${bateria1}% "

				else

					if [[ "${bateria1}" -lt 98 ]]; then

						text="   ${bateria1}% "

					else

						text="   "

					fi

				fi

			fi

		else

			if [[ "${bateria1}" -lt 98 ]]; then

				text="   ${bateria1}% "

			else

				text="   "

			fi

		fi

		imprimir "${color}" "${text}" 1 0

	fi

	### Fecha ###

	imprimir "#FFFFFF" " ${fecha} " 1 1

	sleep 2

done
