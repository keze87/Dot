#!/bin/bash

i3-msg restart;

pid=$(pgrep -a bash | grep barcolor | awk '{print $1}')

while [[ "${pid}" ]]; do

	kill "${pid}"

	pid=$(pgrep -a bash | grep barcolor | awk '{print $1}')

done

( bash ~/.config/i3/barcolor.sh ) &

disown
