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

audioyt="$(youtube-dl -f bestaudio --get-url $link)"
videoyt="$(youtube-dl -f "bestvideo[height<=?1080]" --get-url $link)"
titulo="$(youtube-dl --get-filename $link)"

if [[ $audioyt ]]; then

	aria2c --allow-overwrite=true -c --file-allocation=none --log-level=error -m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=60 -t5 --out="audioyt" "$audioyt"&

else

	zenity --question --text="Sin direccion de audio. Continuar?" --ok-label="De una" --cancel-label="Rescatate"

	case $? in

		1) exit 2;;

		*) echo OK;;

	esac

fi

if [[ $videoyt ]]; then

	aria2c --allow-overwrite=true -c --file-allocation=none --log-level=error -m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=60 -t5 --out="videoyt" "$videoyt"

else

	zenity --question --text="Sin direccion de video. Continuar?" --ok-label="De una" --cancel-label="Rescatate"

	case $? in

		1) exit 3;;

		*) echo OK;;

	esac

fi

zenity --question --text="Descarga completa. Reproducir?" --ok-label="Yup" --cancel-label="Nope"

if [[ $? == 0 ]]; then

	if [[ -f "audioyt" && -f "videoyt" ]]; then

		mpv --title="$titulo" --audio-file="audioyt" "videoyt"

	else

		if [[ -f "audioyt" ]]; then

			mpv --title="$titulo" "audioyt"

		fi

		if [[ -f "videoyt" ]]; then

			mpv --title="$titulo" "videoyt"

		fi

	fi

	zenity --question --text="Guardar" --ok-label="Yup" --cancel-label="Nope"

	if [[ $? != 0 ]]; then

		gvfs-trash "audioyt"
		gvfs-trash "videoyt"

		exit

	fi

fi

if [[ -f "audioyt" && -f "videoyt" ]]; then

	ffmpeg -i "videoyt" -i "audioyt" -c copy -map 0:v:0 -map 1:a:0 "$titulo.mkv"

	if [[ $? == 0 ]]; then

		rm "audioyt"
		rm "videoyt"

	fi

else

	if [[ -f "audioyt" ]]; then

		mv "audioyt" "$titulo"

	fi

	if [[ -f "videoyt" ]]; then

		mv "videoyt" "$titulo"

	fi

fi
