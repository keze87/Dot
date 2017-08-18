#!/bin/bash

cd /etc/X11/ || exit

if ls | grep -q 144; then

	mv xorg.conf xorg.conf.96
	mv xorg.conf.144 xorg.conf

	a="DPI = 144\nReiniciar?"

else

	mv xorg.conf xorg.conf.144
	mv xorg.conf.96 xorg.conf

	a="DPI = 96\nReiniciar?"

fi

zenity --question --text "$a" && systemctl restart sddm.service
