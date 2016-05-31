#!/bin/sh

if [[ $1 ]]; then s=$1; else s="#FFFFFF"; fi

echo -e "{\"version\":1}"
echo -e "["

brillomax=$(cat /sys/class/backlight/intel_backlight/max_brightness)

while :
do

		#brillo=$(xbacklight -get);
		brillo=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
		brillo=$(echo "$brillo * 100 / $brillomax" | bc -l)

		wifi=$(iwgetid -r)

		disco1=$(df -H | grep sdb3 | awk '{print $5}')
		disco2=$(df -H | grep sda3 | awk '{print $5}')

		bateria1=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep perce | awk '{print $2}' | tr -d '%')
		bateria2=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')

		artist=("")
		artist=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 2 "artist"|egrep -v "artist"|egrep -v "array"|cut -b 27-|cut -d '"' -f 1|egrep -v ^$)

		if [[ $artist ]]; then

			title=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 "title"|egrep -v "title"|cut -b 44-|tr -d '"'|egrep -v ^$)

			album=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 "album"|egrep -v "album"|cut -b 44-|tr -d '"'|egrep -v ^$)

		fi

		ram=$(free -h | grep Mem | awk '{print $3}');

		cpu=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input | cut -c1-2)

		fecha=$(date +"%A %d-%m %H:%M:%S")

		volumen=$(amixer get Master | grep Right: | awk {"print \$5"} | tr -d "[]");

		sleep 1

		echo -e "["

		### Spotify ###

		if [[ $artist ]]; then
			if dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -q Playing; then

				echo -e "{\"color\":\"#FFFFFF\","
				#echo -e "\"short_text\":\" N/A \","
				echo -e "\"separator\": false,"
				echo -e "\"separator_block_width\": 0,"
				echo -e "\"full_text\":\" ${artist} \"},"

				echo -e "{\"color\":\"$s\","
				echo -e "\"separator\": false,"
				echo -e "\"separator_block_width\": 0,"
				echo -e "\"full_text\":\"-\"},"

				echo -e "{\"color\":\"#FFFFFF\","
				echo -e "\"separator\": false,"
				echo -e "\"separator_block_width\": 0,"
				#echo -e "\"short_text\":\"\","
				echo -e "\"full_text\":\" ${album} \"},"

				echo -e "{\"color\":\"$s\","
				#echo -e "\"short_text\":\"\","
				echo -e "\"separator\": false,"
				echo -e "\"separator_block_width\": 0,"
				echo -e "\"full_text\":\"-\"},"

				echo -e "{\"color\":\"#FFFFFF\","
				echo -e "\"full_text\":\" ${title} \"},"

			fi
		fi

		### Brillo ###

		if [[ $brillo ]]; then

			if [ ${brillo%.*} -eq "100" ]; then

				brillo=("")

			else

				echo -e "{\"color\":\"#FFFFFF\","
				echo -e "\"full_text\":\" BRILLO: ${brillo%.*} \"},"

			fi

		fi

		### WiFi ###

		if [[ $wifi ]]; then

			speed=$(sh .config/i3/speed.sh)

			if [[ $speed = "0↓ 0↑" ]]; then
				speed=("")
			else
				speed=(" ${speed}")
			fi

			echo -e "{\"color\":\"#FFFFFF\","
			echo -e "\"full_text\":\" WiFi:${speed} (${wifi}) \"},"

		else

			echo -e "{\"color\":\"#FF0000\","
			echo -e "\"full_text\":\" Sin WiFi \"},"

		fi

		### Volumen ###

		echo -e "{\"color\":\"#FFFFFF\","
		#echo -e "\"short_text\":\"\","
		echo -e "\"full_text\":\" S: ${volumen} \"},"

		### Root ###

		echo -e "{\"color\":\"#FFFFFF\","
		echo -e "\"short_text\":\"\","
		echo -e "\"full_text\":\" /: ${disco1} \"},"

		### Home ###

		echo -e "{\"color\":\"#FFFFFF\","
		echo -e "\"short_text\":\"\","
		echo -e "\"full_text\":\" H: ${disco2} \"},"

		### RAM ###

		echo -e "{\"color\":\"#FFFFFF\","
		echo -e "\"short_text\":\"\","
		echo -e "\"full_text\":\" RAM: ${ram} \"},"

		### CPU ###

		if [[ $cpu -lt 60 ]]; then
			echo -e "{\"color\":\"#FFFFFF\","
		else
			if [[ $cpu -lt 80 ]]; then
				echo -e "{\"color\":\"#FFA500\","
			else
				echo -e "{\"color\":\"#FF0000\","
			fi
		fi

		echo -e "\"full_text\":\"T: ${cpu}°C \"},"

		### Bateria ##

		if [ $bateria1 -gt 50 ]; then
			echo -e "{\"color\":\"#FFFFFF\","
		else
			if [[ $bateria1 -gt 20 ]]; then
				echo -e "{\"color\":\"#FFA500\","
			else
				echo -e "{\"color\":\"#FF0000\","
			fi
		fi

		#echo -e "\"full_text\":\"🔌: ${bateria1} (${bateria2}) \"},"

		if [ $bateria2 = "discharging" ]; then
			echo -e "\"full_text\":\"BAT: ${bateria1}% \"},"
		else
			echo -e "\"full_text\":\"AC: ${bateria1}% \"},"
		fi

		### Fecha ###

		echo -e "{\"color\":\"#FFFFFF\","
		echo -e "\"full_text\":\" ${fecha} \"}"

		echo -e "],"

		sleep 1

done
