#!/bin/sh

if [[ $1 ]]; then

	link=$1;

else

	link=$(xclip -o);

fi

if [[ $link ]]; then

	echo $link; echo

else

	exit 1;

fi

#set -x

tmp="$HOME/.cache"

audio="$(youtube-dl -f bestaudio --get-url $link)"
video="$(youtube-dl -f "bestvideo[height<=?1080]" --get-url $link)"
title="$(youtube-dl --get-filename $link)"

if [[ $audio == "" && $video == "" ]]; then

	echo "Nada que descargar"

	exit 4

fi

if [[ $audio ]]; then

	aria2c --allow-overwrite=true -c --file-allocation=none --log-level=error -m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=60 -t5 --dir="$tmp" --out="audio$title" "$audio"&

else

	zenity --question --text="Sin direccion de audio. Continuar?" --ok-label="Yup" --cancel-label="Nope"

	case $? in

		1) exit 2;;

		*) echo OK;;

	esac

fi

if [[ $video ]]; then

	aria2c --allow-overwrite=true -c --file-allocation=none --log-level=error -m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=60 -t5 --dir="$tmp" --out="video$title" "$video"

else

	zenity --question --text="Sin direccion de video. Continuar?" --ok-label="Yup" --cancel-label="Nope"

	case $? in

		1) exit 3;;

		*) echo OK;;

	esac

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

		gvfs-trash "$tmp/audio$title"
		gvfs-trash "$tmp/video$title"

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

		mv "$tmp/audio$title" "$tmp/$title"

	fi

	if [[ -f "$tmp/video$title" ]]; then

		mv "$tmp/video$title" "$tmp/$title"

	fi

fi

ruta=$(zenity --file-selection --save --confirm-overwrite --filename="$title.mkv");

if [[ $ruta ]]; then

	mv "$tmp/$title.mkv" "$ruta"

else

	echo "Queda en cache"

fi
