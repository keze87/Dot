#!/bin/sh

#set -x

if [[ $2 ]]; then

	link=$2;

	if [[ $1 = *[[:digit:]]* && $1 -le 9999 ]]; then #$1 numero?

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

name=$(youtube-dl -e "${link}")

if [[ $? == 0 ]]; then

	echo -e "${link}\n"

else

	exit 1;

fi

tmp="${HOME}/.cache"

if [[ -f "${tmp}"/ytlog ]]; then

	rm "${tmp}"/ytlog

fi

touch "${tmp}"/ytlog

args='--allow-overwrite=true -c --file-allocation=none --log-level=error
-m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=0 -t5'

if [[ ${maxres} == 0 ]]; then

	stdbuf -o0 youtube-dl -q --no-playlist -f "bestvideo+bestaudio/best" --exec "echo {} > ${tmp}/title" \
	--external-downloader "aria2c" --external-downloader-args "${args}" \
	-o "${tmp}/%(title)s-%(id)s.%(ext)s" "${link}" 2>&1 | tee -a "${tmp}"/ytlog | \
	grep --line-buffered -oP '^\[#.*?\K([0-9.]+\%)' | \
	zenity --progress --title="Download" --text="${name}\n" \
	--percentage=0 --auto-close --no-cancel

else

	stdbuf -o0 youtube-dl -q --no-playlist -f "bestvideo[height<=?${maxres}]+bestaudio/best[height<=?${maxres}]/best" \
	--exec "echo {} > ${tmp}/title" --external-downloader "aria2c" --external-downloader-args "${args}" \
	-o "${tmp}/%(title)s-%(id)s.%(ext)s" "${link}" 2>&1 | tee -a "${tmp}"/ytlog |\
	grep --line-buffered -oP '^\[#.*?\K([0-9.]+\%)' | \
	zenity --progress --title="Download" --text="${name}\n" \
	--percentage=0 --auto-close --no-cancel

fi

if [[ $? != 0 ]]; then

	exit 1;

fi

youtube-dl --list-subs "${link}" &> "${tmp}/subs"

if grep -q "video doesn't have subtitles" "${tmp}/subs"; then

	rm "${tmp}/subs"

fi

title=$(cat "${tmp}"/title)

if [[ -f "${tmp}/subs" ]]; then

	rm "${tmp}/subs"

	youtube-dl --write-sub --skip-download \
	-o "${tmp}/%(title)s-ytsub-%(id)s.%(ext)s" "${link}"

	sub=$(ls "${tmp}" | grep -- -ytsub-)
	sub="${tmp}/${sub}"

fi

rm "${tmp}/title"

zenity --question --text="Descarga completa. Reproducir?" \
--ok-label="Yup" --cancel-label="Nope"

if [[ $? == 0 ]]; then

	if [[ ${sub} ]]; then

		mpv --no-terminal --sub-file="${sub}" "${title}"

	else

		mpv --no-terminal "${title}"

	fi

	zenity --question --text="Guardar" \
	--ok-label="Yup" --cancel-label="Nope"

	if [[ $? != 0 ]]; then

		rm "${title}"

		if [[ ${sub} ]]; then

			rm "${sub}"

		fi

		exit

	fi

fi

ruta=$(zenity --file-selection --save --confirm-overwrite \
--filename="${name}.${title: -3}");

if [[ ${ruta} ]]; then

	mv "${title}" "${ruta}"

	if [[ ${sub} ]]; then

		mv "${sub}" "${ruta::-4}.${sub: -3}"

	fi

else

	gvfs-trash "${title}"

	if [[ ${sub} ]]; then

		gvfs-trash "${sub}"

	fi

	echo "Queda en papelera"

fi
