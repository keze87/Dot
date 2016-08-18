#!/bin/sh

#i3bar -> $TERM == 'dumb'

if pgrep -a -x -f "sh ~/.config/i3/barcolor.sh"; then

	killall sh ~/.config/i3/barcolor.sh

fi

sh ~/.config/i3/barcolor.sh "Desktop" > /dev/null &

up=true

echo -e '{"version":1}
		[
			[
				{
					"color":"#FF0000",
					"full_text":" Iniciando "
				}
			],'

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

			player=""

		fi

	fi

	if [[ ${player} ]]; then

		artist=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | \
		egrep -A 2 "artist" | egrep -v "artist" | egrep -v "array" | \
		cut -b 27- | tr '"' "'" | egrep -v ^$)

		title=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | \
		egrep -A 1 "title" | egrep -v "title" | cut -b 44- | tr '"' "'" | \
		egrep -v ^$)

		album=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | \
		egrep -A 1 "album" | egrep -v "album" | cut -b 44- | tr '"' "'" | \
		egrep -v ^$)

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

	if [[ -f ${HOME}/memo ]]; then

		memo=$(tr -s "\n" " " < ~/memo)

	fi

	if date +"%M:%S" | grep -q '0:0'; then

		tenmin=true

	else

		tenmin=false

	fi

	if [[ ${tenmin} == true || ! ${ip} ]]; then

		ip=$(ip r | grep default | cut -d ' ' -f 3)

	fi

	nvidia=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

	volumen=$(amixer get Master | grep "Front Right:" | awk {"print \$5"} | tr -d "[]%")

	if [[ ${tenmin} == true || ! ${disco1} || ! ${disco2} ]]; then

		disco1=$(df | grep sdb1 | awk '{print $5}')
		disco2=$(df | grep sda1 | awk '{print $5}')

	fi

	ram=$(free -h | grep Mem | awk '{print $3}')

	cpu=$(cat /sys/devices/platform/coretemp.0/hwmon/*/temp1_input | cut -c1-2)

	fecha=$(date +"%A %d-%m-%Y %H:%M:%S")

	clear

	echo -e "["

	### Spotify ###

	if [[ ${player} && ${title} ]]; then

		s=$(tail -n1 .config/i3/config)

		echo -e "{
					\"color\":\"${s}\",
					\"separator\": false,
					\"separator_block_width\": 0,"

		if [[ ${player} == 'spotify' ]]; then

			echo -e "\"full_text\":\" \"
					 },"

		else

			echo -e "\"full_text\":\" \"
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
							\"full_text\":\"--\"
						 },"

			fi
		fi

		if [[ ${album} ]]; then

			echo -e "{
						\"color\":\"#FFFFFF\",
						\"separator\": false,
						\"separator_block_width\": 0,
						\"short_text\":\" N/A \",
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

	if ping -q -w 1 -c 1 "${ip}" > /dev/null; then

		speed=$(sh ~/.config/i3/speed.sh "eno1")

		if [[ "${speed}" != '0 K↓ 0 K↑' ]]; then

			echo -e "{
						\"color\":\"#FFFFFF\",
						\"full_text\":\"   ${speed} \"
					},"

		fi

		up=true

	else

		time=$(awk '{print $0/60;}' /proc/uptime)

		if [[ ${time%.*} -gt 1 ]]; then

			if [[ ${up} == true ]]; then

				mpv --really-quiet /usr/share/sounds/freedesktop/stereo/dialog-information.oga

				up=false

			fi

		fi

		echo -e "{
					\"color\":\"#FF0000\",
					\"full_text\":\"   Sin Internet \"
				 },"

	fi

	### El Memo ###

	if [[ ${memo} ]]; then

		echo -e "{
					\"color\":\"#FFFFFF\",
					\"full_text\":\"  ${memo::-1} \"
				 },"

		memo=""

	fi

	### Nvidia ###

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

	### Volumen ###

	echo -e "{
				\"color\":\"#FFFFFF\","

	if [ "${volumen}" -lt 10 ]; then

		echo -e "\"full_text\":\"   ${volumen}% \"},"

	else

		if [[ "${volumen}" -lt 40 ]]; then

			echo -e "\"full_text\":\"   ${volumen}% \"},"

		else

			echo -e "\"full_text\":\"   ${volumen}% \"},"

		fi

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

	if [[ $cpu -lt 60 ]]; then

		echo -e "{ \"color\":\"#FFFFFF\","

	else

		if [[ $cpu -lt 80 ]]; then

			echo -e "{ \"color\":\"#FFA500\","

		else

			echo -e "{ \"color\":\"#FF0000\","

		fi

	fi

	echo -e "\"full_text\":\"   ${cpu}°C \" },"

	### Fecha ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\" ${fecha} \"
			 }"

	echo -e "],"

	sleep 2

done
