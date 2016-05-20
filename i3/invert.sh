#! /bin/bash

if ps -fC compton | grep -q invert; then

	pkill compton
	compton --config /home/keze/.compton.conf

else

	pkill compton

	ID=$(xdotool getactivewindow)
	CLASS=$(xprop -id "$ID"  | grep "WM_CLASS" | awk '{print $4}')
	COND="class_g=${CLASS}"

	compton --config /home/keze/.compton.conf --invert-color-include "$COND" &

fi
