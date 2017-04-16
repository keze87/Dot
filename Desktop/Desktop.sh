#!/bin/bash

dir=~/.Dot/Desktop
olddir=~/Dot_Old

### Home ###

files="dpi.sh conkyrc"

for file in ${files}; do

	if [ -f ~/."${file}" ]; then

		mv ~/."${file}" "${olddir}"/Home/

	fi

	ln -s "${dir}"/Home/"${file}" ~/."${file}"

done

### i3 ###

files="config monitor.sh"

for file in ${files}; do

	if [ -f ~/.config/i3/"${file}" ]; then

		mv ~/.config/i3/"${file}" "${olddir}"/i3/

	fi

	ln -s "${dir}"/i3/"${file}" ~/.config/i3/"${file}"

done

### mpv ###

files="mpv.conf"

for file in ${files}; do

	ln -s "${dir}"/mpv/"${file}" ~/.config/mpv/"${file}"

done
