#!/bin/bash

i3-msg restart;

pid=$(pgrep -a sh | grep barcolor | awk '{print $1}')

if [[ "${pid}" ]]; then

	kill "${pid}"

fi

( sh ~/.config/i3/barcolor.sh ) &

disown
