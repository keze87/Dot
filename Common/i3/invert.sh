#! /bin/bash

if pgrep -a compton | grep -q invert; then

	pkill compton
	compton

else

	pkill compton

	ID=$(xdotool getactivewindow)
	CLASS=$(xprop -id "${ID}"  | grep "WM_CLASS" | awk '{print $4}')
	COND="class_g=${CLASS}"

	compton --invert-color-include "${COND}" &

fi
