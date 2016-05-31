#/bin/bash

	sleep 1;
	conky;

	sleep 1;
	albert &

	if lsusb | grep 1142; then
		steam -silent&
	else
		if lsusb | grep 1102; then
			steam -silent&
		fi
	fi

	while true; do

		xdotool mousemove_relative 0 1;
		xdotool mousemove_relative 0 -1;
		sleep 599;

	done
