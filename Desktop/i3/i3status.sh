#!/bin/sh

if pgrep -a -x -f "sh ~/.config/i3/barcolor.sh"; then

	killall sh ~/.config/i3/barcolor.sh

fi

sh ~/.config/i3/barcolor.sh "Desktop" > /dev/null &

if [[ $1 ]]; then

	s=$1;

else

	s="#FFFFFF";

fi

up=true

echo -e "{\"version\":1}\n["

while true; do

	if dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
	/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
	string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | \
	grep -q Playing; then

		player="spotify"

	else

		if dbus-send --print-reply --dest=org.mpris.MediaPlayer2.audacious \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' \
		string:'PlaybackStatus' | grep -q Playing; then

			player="audacious"

		else

			player=""

		fi

	fi

	if [[ $player ]]; then

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

		if [[ $artist ]]; then

			artist=${artist::-1}

		fi

		if [[ $album ]]; then

			album=${album::-1}

		fi

		if [[ $title ]]; then

			title=${title::-1}

		fi

	fi

	if [[ -f ${HOME}/memo ]]; then

		memo=$(tr -s "\n" " " < ${HOME}/memo)

	fi

	nvidia=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

	volumen=$(amixer get Master | grep "Front Right:" | awk {"print \$5"} | tr -d "[]");

	disco1=$(df | grep sdb1 | awk '{print $5}')
	disco2=$(df | grep sda1 | awk '{print $5}')

	ram=$(free -h | grep Mem | awk '{print $3}');

	cpu=$(cat /sys/devices/platform/coretemp.0/hwmon/*/temp1_input | cut -c1-2)

	fecha=$(date +"%A %d-%m-%Y %H:%M:%S")

	echo -e "["

	### Spotify ###

	if [[ $player ]]; then

		if [[ $artist ]]; then

			echo -e "{
						\"color\":\"#FFFFFF\",
						\"separator\": false,
						\"separator_block_width\": 0,
						\"full_text\":\" ${artist} \"
					 },"

		fi

		if [[ $album || $title ]]; then
			if [[ $artist ]]; then

				echo -e "{
							\"color\":\"$s\",
							\"separator\": false,
							\"separator_block_width\": 0,
							\"full_text\":\"--\"
						 },"

			fi
		fi

		if [[ $album ]]; then

			echo -e "{
						\"color\":\"#FFFFFF\",
						\"separator\": false,
						\"separator_block_width\": 0,
						\"short_text\":\" N/A \",
						\"full_text\":\" ${album} \"
					 },"

		fi

		if [[ $album && $title ]]; then

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

	### El Memo ###

	if [[ ${memo} ]]; then

		echo -e "{
					\"color\":\"#FFFFFF\",
					\"full_text\":\" ${memo::-1} \"
				 },"

		memo=""

	fi

	### Internet ###

	if ping -q -w 1 -c 1 $(ip r | grep default | cut -d ' ' -f 3) > /dev/null; then

		echo -e "{
					\"color\":\"#FFFFFF\",
					\"full_text\":\" NET: $(sh ~/.config/i3/speed.sh "eno1") \"
				},"

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
					\"full_text\":\" Sin Internet \"
				 },"

	fi

	### Nvidia ###

	if [[ $nvidia -lt 60 ]]; then

		echo -e "{ \"color\":\"#FFFFFF\","

	else

		if [[ $nvidia -lt 80 ]]; then

			echo -e "{ \"color\":\"#FFA500\","

		else

			echo -e "{ \"color\":\"#FF0000\","

		fi

	fi

	echo -e "\"full_text\":\" NVIDIA: ${nvidia} °C \" },"

	### Volumen ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\" S: ${volumen} \"
			 },"

	### Root ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\" ROOT: ${disco1} \"
			 },"

	### Home ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\" HOME: ${disco2} \"
			 },"

	### RAM ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\" RAM: ${ram} \"
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

	echo -e "\"full_text\":\" T: ${cpu}°C \" },"

	### Fecha ###

	echo -e "{
				\"color\":\"#FFFFFF\",
				\"full_text\":\" ${fecha} \"
			 }"

	echo -e "],"

	sleep 2

done
