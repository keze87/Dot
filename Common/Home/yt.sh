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

tmp="${HOME}/.cache"
args='--allow-overwrite=true -c --file-allocation=none --log-level=error -m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=60 -t5'

youtube-dl -e $link > "${tmp}/title" &

if [[ $maxres == 0 ]]; then

	youtube-dl -f "bestvideo+bestaudio/best" --external-downloader "aria2c" --external-downloader-args "${args}" -o "${tmp}/%(title)s-%(id)s.%(ext)s" $link

else

	youtube-dl -f "bestvideo[height<=?$maxres]+bestaudio/best[height<=?$maxres]/best" --external-downloader "aria2c" --external-downloader-args "${args}" -o "${tmp}/%(title)s-%(id)s.%(ext)s" $link

fi

youtube-dl --list-subs $link > "${tmp}/subs"

if cat "${tmp}/subs" | grep -q "video doesn't have subtitles"; then

	rm "${tmp}/subs"

fi

wait

title=$(find ${tmp} -name "$(cat ${tmp}/title)*" -type f -printf '%f\n' -quit)

if [[ -f "${tmp}/subs" ]]; then

	rm "${tmp}/subs"

	youtube-dl --write-sub --skip-download -o "${tmp}/%(title)s-ytsub-%(id)s.%(ext)s" $link

	sub=$(find ${tmp} -name "$(cat ${tmp}/title)-ytsub-*" -type f -printf '%f\n' -quit)

fi

rm "${tmp}/title"

zenity --question --text="Descarga completa. Reproducir?" --ok-label="Yup" --cancel-label="Nope"

if [[ $? == 0 ]]; then

	if [[ ${sub} ]]; then

		mpv --sub-file="${tmp}/${sub}" "${tmp}/${title}"

	else

		mpv "${tmp}/${title}"

	fi

	zenity --question --text="Guardar" --ok-label="Yup" --cancel-label="Nope"

	if [[ $? != 0 ]]; then

		rm "${tmp}/${title}"

		if [[ ${sub} ]]; then

			rm "${tmp}/${sub}"

		fi

		exit

	fi

fi

ruta=$(zenity --file-selection --save --confirm-overwrite --filename="${title}");

if [[ ${ruta} ]]; then

	mv "${tmp}/${title}" "${ruta}"

	if [[ ${sub} ]]; then

		mv "${tmp}/${sub}" "${ruta}.sub"

	fi

else

	gvfs-trash "${tmp}/${title}"

	if [[ ${sub} ]]; then

		gvfs-trash "${tmp}/${sub}"

	fi

	echo "Queda en papelera"

fi
