#!/bin/sh

#set -x

if [[ $2 ]]; then

	link=$2;

	if [[ $1 = *[[:digit:]]* && $1 -le 9999 ]]; then

		maxres=$1;

	else

		exit 5;

	fi

else

	if [[ $1 ]]; then

		if [[ $1 = *[[:digit:]]* && $1 -le 9999 ]]; then #$1 numero?

			maxres=$1;

			link=$(xclip -o);

		else

			link=$1

			maxres=1080

		fi

	else

		link=$(xclip -o);

		maxres=1080

	fi

fi

if [[ $link ]]; then

	echo $link; echo

else

	exit 1;

fi

tmp="$HOME/.cache"

audio="$(youtube-dl -f bestaudio --get-url $link)"
title="$(youtube-dl --get-filename $link)"

if [[ $maxres == 0 ]]; then

	video="$(youtube-dl -f bestvideo --get-url $link)"

else

	video="$(youtube-dl -f "bestvideo[height<=?$maxres]" --get-url $link)"

fi

if [[ $audio == "" && $video == "" ]]; then

	echo "Nada que descargar"

	exit 4

fi

if [[ $video == "" ]]; then

	zenity --question --text="Sin direccion de video. Continuar?" --ok-label="Yup" --cancel-label="Nope"

	case $? in

		1) exit 3;;

		*) echo OK;;

	esac

fi

if [[ $audio ]]; then

	aria2c --auto-file-renaming=false --allow-overwrite=false -c --file-allocation=none --log-level=error -m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=60 -t5 --dir="$tmp" --out="audio$title" "$audio"&

else

	zenity --question --text="Sin direccion de audio. Continuar?" --ok-label="Yup" --cancel-label="Nope"

	case $? in

		1) exit 2;;

		*) echo OK;;

	esac

fi

if [[ $video ]]; then

	aria2c --auto-file-renaming=false --allow-overwrite=false -c --file-allocation=none --log-level=error -m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=60 -t5 --dir="$tmp" --out="video$title" "$video"

fi

zenity --question --text="Descarga completa. Reproducir?" --ok-label="Yup" --cancel-label="Nope"

if [[ $? == 0 ]]; then

	if [[ -f "$tmp/audio$title" && -f "$tmp/video$title" ]]; then

		mpv --audio-file="$tmp/audio$title" "$tmp/video$title"

	else

		if [[ -f "$tmp/audio$title" ]]; then

			mpv "$tmp/audio$title"

		fi

		if [[ -f "$tmp/video$title" ]]; then

			mpv "$tmp/video$title"

		fi

	fi

	zenity --question --text="Guardar" --ok-label="Yup" --cancel-label="Nope"

	if [[ $? != 0 ]]; then

		rm "$tmp/audio$title"
		rm "$tmp/video$title"

		exit

	fi

fi

if [[ -f "$tmp/audio$title" && -f "$tmp/video$title" ]]; then

	ffmpeg -i "$tmp/video$title" -i "$tmp/audio$title" -c copy -map 0:v:0 -map 1:a:0 "$tmp/$title.mkv"

	if [[ $? == 0 ]]; then

		rm "$tmp/audio$title"
		rm "$tmp/video$title"

	fi

else

	if [[ -f "$tmp/audio$title" ]]; then

		mv "$tmp/audio$title" "$tmp/$title.mkv"

	fi

	if [[ -f "$tmp/video$title" ]]; then

		mv "$tmp/video$title" "$tmp/$title.mkv"

	fi

fi

ruta=$(zenity --file-selection --save --confirm-overwrite --filename="$title.mkv");

if [[ $ruta ]]; then

	mv "$tmp/$title.mkv" "$ruta"

else

	gvfs-trash "$tmp/$title"

	echo "Queda en papelera"

fi
