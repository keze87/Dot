#!/bin/bash

i3-msg restart;

pid=$(pgrep -a bash | grep barcolor | awk '{print $1}')

if [[ "${pid}" ]]; then

	kill "${pid}"

fi

( bash ~/.config/i3/barcolor.sh ) &

disown
