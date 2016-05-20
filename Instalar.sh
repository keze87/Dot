#!/bin/bash

dir=~/.Dot
olddir=~/Dot_Old

mkdir $olddir

### Home ###

cd $dir/Home/
files="compton.conf zshrc dpi.sh mouse.sh pop.sh conkyrc"

mkdir $olddir/Home

for file in $files; do

	mv ~/.$file $olddir/Home/
	ln -s $dir/Home/$file ~/.$file

done

### Config ###

folders="i3 mpv mpv2"

for folder in $folders; do

	mv ~/.config/$folder $olddir/
	ln -s $dir/$folder ~/.config/$folder

done
