#!/bin/bash

dir="${HOME}/.Dot/Common"
olddir="${HOME}/Dot_Old"

### Home ###

files="compton.conf zshrc mouse.sh pop.sh yt.sh vimrc ss.sh"

mkdir "${olddir}"/Home

for file in ${files}; do

	if [ -f ~/."${file}" ]; then

		mv ~/."${file}" "${olddir}"/Home/

	fi

	ln -s "${dir}"/Home/"${file}" ~/."${file}"

done

### i3 ###

files="volumen.sh invert.sh tab.sh work.sh apagar.sh speed.sh trans.sh instance.sh barcolor.sh"

mkdir "${olddir}"/i3

if [ -d ~/.config/i3 ]; then

	mv ~/.config/i3/ "${olddir}"/

fi

mkdir ~/.config/i3

for file in ${files}; do

	ln -s "${dir}"/i3/"${file}" ~/.config/i3/"${file}"

done
