#!/bin/sh

#i3bar -> $TERM == 'dumb'

echo -e '{"version":1}
		[
			[
				{
					"color":"#000000",
					"full_text":"I"
				}
			],'

if [[ -f ~/.dotlaptop ]]; then

	desktop=false;
	laptop=true;

fi

if [[ ${laptop} ]]; then

	brillomax=$(cat /sys/class/backlight/intel_backlight/max_brightness)

fi

up=true
headphones=false
s="#FFFFFF"

while true; do

	if dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
	/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
	string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' 2>/dev/null | \
	grep -q Playing; then

		player="spotify"

	else

		if dbus-send --print-reply --dest=org.mpris.MediaPlayer2.audacious \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' \
		string:'PlaybackStatus' 2>/dev/null | grep -q Playing; then

			player="audacious"

		else

			if dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotifywebplayer \
			/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
			string:'org.mpris.MediaPlayer2.Player' \
			string:'PlaybackStatus' 2>/dev/null | grep -q Playing; then

				player="spotifywebplayer"

			else

				player=""

			fi

		fi

	fi

	if [[ ${player} ]]; then

		artist=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | \
		egrep -A 2 "artist" | egrep -v "artist" | egrep -v "array" | \
		cut -d'"' -f2- | head -n 1 | tr '"' "'" | egrep -v ^$)

		title=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | \
		egrep -A 1 "title" | egrep -v "title" | cut -d'"' -f2- | head -n 1 | \
		 tr '"' "'" | egrep -v ^$)

		album=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | \
		egrep -A 1 "album" | egrep -v "album" | cut -d'"' -f2- | head -n 1 | \
		 tr '"' "'" | egrep -v ^$)

		if [[ ${artist} ]]; then

			artist=${artist::-1}

		fi

		if [[ ${album} ]]; then

			album=${album::-1}

		fi

		if [[ ${title} ]]; then

			title=${title::-1}

		fi

	fi

	if [[ -f ~/memo ]]; then

		memo=$(grep -v '#' < ~/memo | tr -s "\n" " ")

	fi

	if date +"%M:%S" | grep -q '0:0'; then

		tenmin=true

	else

		tenmin=false

	fi

	ram=$(free -h | grep Mem | awk '{print $3}')

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

	clear

	echo -e "["

	if [[ (${player} && ${title}) || ${headphones} == true ]]; then

		s=$(tail -n1 .config/i3/config | tr -d "\t")

	fi

	### Spotify ###

	if [[ ${player} && ${title} ]]; then

		echo -e "{
					\"color\":\"${s}\",
					\"separator\": false,
					\"separator_block_width\": 0,"

		if [[ ${player} == 'spotify' || ${player} == 'spotifywebplayer' ]]; then

			echo -e "\"full_text\":\"  \"
					 },"

		else

			echo -e "\"full_text\":\"  \"
					 },"

		fi

		if [[ ${artist} ]]; then

			echo -e "{
						\"color\":\"#FFFFFF\",
						\"separator\": false,
						\"separator_block_width\": 0,
						\"full_text\":\" ${artist} \"
					 },"

		fi

		if [[ ${album} || ${title} ]]; then
			if [[ ${artist} ]]; then

				echo -e "{
							\"color\":\"$s\",
							\"separator\": false,
							\"separator_block_width\": 0,
							\"short_text\":\"\",
							\"full_text\":\"--\"
						 },"

			fi
		fi

		if [[ ${album} ]]; then

			echo -e "{
						\"color\":\"#FFFFFF\",
						\"separator\": false,
						\"separator_block_width\": 0,
						\"short_text\":\"\",
						\"full_text\":\" ${album} \"
					 },"

		fi

		if [[ ${album} && ${title} ]]; then

			echo -e "{
						\"color\":\"$s\",
						\"separator\": false,
						\"separator_block_width\": 0,
						\"full_text\":\"--\"
					 },"

		fi

		echo -e "{
					\"color\":\"#FFFFFF\",
					\"full_text\":\" ${title} \"
				 },"

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

			echo -e "{
						\"color\":\"#FFFFFF\","

			if [[ $speed == "0 K↓ 0 K↑" ]]; then

				echo -e "\"full_text\":\"   ${wifi} \"
					 },"

			else

				echo -e "\"full_text\":\"   ${speed} (${wifi}) \"
					 },"

			fi

			up=true
			upsonido=true

		else

			up=false

		fi

	else # desktop

		if ping -q -w 1 -c 1 "${ip}" > /dev/null; then

			speed=$(sh ~/.config/i3/speed.sh "eno1")

			if [[ "${speed}" != '0 K↓ 0 K↑' ]]; then

				echo -e "{
							\"color\":\"#FFFFFF\",
							\"full_text\":\"   ${speed} \"
						},"

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

		echo -e "{
					\"color\":\"#FF0000\",
					\"full_text\":\"   Sin Internet \"
				 },"

	fi

	### Brillo ###

	if [[ ${brillo} ]]; then

		if [ "${brillo%.*}" -eq "100" ]; then

			brillo=""

		else

			echo -e "{
						\"color\":\"#FFFFFF\",
						\"full_text\":\"   ${brillo%.*} \"
					 },"

		fi

	fi

	### El Memo ###

	if [[ ${memo} ]]; then

		color=$(grep '#' < ~/memo | grep -v ':' | tr -c -d '[:alnum:]')

		if ! echo "${color}" | grep -q '^[0-9A-F]\{6\}$'; then

			color='FFFFFF'

		fi

		echo -e "{
					\"color\":\"#${color}\",
					\"short_text\":\"   Memo \",
					\"full_text\":\"   ${memo::-1} \"
				 },"

		memo=""

	fi

	### Nvidia ###

	if [[ ${nvidia} ]]; then

		if [[ ${nvidia} -lt 60 ]]; then

			echo -e "{ \"color\":\"#FFFFFF\","

		else

			if [[ ${nvidia} -lt 80 ]]; then

				echo -e "{ \"color\":\"#FFA500\","

			else

				echo -e "{ \"color\":\"#FF0000\","

			fi

		fi

		echo -e "\"full_text\":\"   ${nvidia} °C \" },"

	fi

	### Volumen ###

	echo -e "{
				\"color\":\"#FFFFFF\","

	if [[ ${headphones} == true ]]; then

		echo -e "\"separator_block_width\": 0,"

	fi

	if [ "${volumen}" -lt 10 ]; then

		echo -e "\"full_text\":\"   ${volumen}% \"},"

	else

		if [[ "${volumen}" -lt 40 ]]; then

			echo -e "\"full_text\":\"   ${volumen}% \"},"

		else

			echo -e "\"full_text\":\"   ${volumen}% \"},"

		fi

	fi

	if [[ ${headphones} == true ]]; then

		echo -e "{
				\"color\":\"${s}\",
				\"full_text\":\"  \"
			 },"

	fi

	### Root ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\"   ${disco1} \"
			 },"

	### Home ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\"   ${disco2} \"
			 },"

	### RAM ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\"   ${ram} \"
			 },"

	### CPU ###

	if [[ ${cpu} -lt 60 ]]; then

		echo -e "{ \"color\":\"#FFFFFF\","

	else

		if [[ ${cpu} -lt 80 ]]; then

			echo -e "{ \"color\":\"#FFA500\","

		else

			echo -e "{ \"color\":\"#FF0000\","

		fi

	fi

	echo -e "\"full_text\":\"   ${cpu}°C \" },"

	### Bateria ##

	if [[ ${bateria1} ]]; then

		if [ "${bateria1}" -gt 50 ]; then

			echo -e "{\"color\":\"#FFFFFF\","

		else

			if [[ "${bateria1}" -gt 20 ]]; then

				echo -e "{\"color\":\"#FFA500\","

			else

				echo -e "{\"color\":\"#FF0000\","

			fi

		fi

		if [ "${bateria2}" = "discharging" ]; then

			if [ "${bateria1}" -lt 30 ]; then

				echo -e "\"full_text\":\"   ${bateria1}% \"},"

			else

				if [[ "${bateria1}" -lt 65 ]]; then

					echo -e "\"full_text\":\"   ${bateria1}% \"},"

				else

					echo -e "\"full_text\":\"   ${bateria1}% \"},"

				fi

			fi

		else

			echo -e "\"full_text\":\"   ${bateria1}% \"},"

		fi

	fi

	### Fecha ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\" ${fecha} \"
			 }"

	echo -e "],"

	sleep 2

done
