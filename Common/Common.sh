#!/bin/bash

set -x

dir=~/.Dot/Common
olddir=~/Dot_Old

### Home ###

files="compton.conf zshrc mouse.sh pop.sh yt.sh"

mkdir $olddir/Home

for file in $files; do

	if [ -f ~/.$file ]; then

		mv ~/.$file $olddir/Home/

	fi

	ln -s $dir/Home/$file ~/.$file

done

### i3 ###

files="volumen.sh invert.sh tab.sh work.sh apagar.sh speed.sh trans.sh"

mkdir $olddir/i3
mkdir ~/.config/i3

for file in $files; do

	if [ -f ~/.config/i3/$file ]; then

		mv ~/.config/i3/$file $olddir/i3/

	fi

	ln -s $dir/i3/$file ~/.config/i3/$file

done

### mpv ###

files="mpv.conf mvtools.vpy input.conf"

mkdir $olddir/mpv
mkdir ~/.config/mpv

for file in $files; do

	if [ -f ~/.config/mpv/$file ]; then

		mv ~/.config/mpv/$file $olddir/mpv/

	fi

	ln -s $dir/mpv/$file ~/.config/mpv/$file

done
