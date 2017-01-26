#!/bin/bash

dir=~/.Dot
olddir=~/Dot_Old

### Home ###

files="vimrc yt-dialog.sh"

for file in ${files}; do

	if [ -f ~/."${file}" ]; then

		mv ~/."${file}" "${olddir}"/Home/

	fi

	ln -s "${dir}"/Common/Home/"${file}" ~/."${file}"

done

if [ -f ~/.zshrc ]; then

	mv ~/.zshrc "${olddir}"/Home/

fi

ln -s "${dir}"/Termux/Home/zshrc ~/.zshrc
