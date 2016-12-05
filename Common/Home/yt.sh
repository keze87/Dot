#!/bin/sh

if [[ $2 ]]; then

	link=$2;

	if [[ $1 = *[[:digit:]]* && $1 -le 9999 ]]; then #$1 numero?

		maxres=$1;

	else

		exit 1;

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

tmp=~/.cache

if [[ -f "${tmp}"/ytlog ]]; then

	rm "${tmp}"/ytlog

fi

touch "${tmp}"/ytlog

if [[ ${maxres} == 1000 ]]; then

	aux="aux"

	while [[ ${aux} != *[[:digit:]]* ]] ; do

		(

			sleep 0.2
			i3-msg move position mouse

		) &

		aux=$(zenity --entry --text="${link}\nResolucion?" --entry-text="1000")

		if [[ $? != 0 ]]; then

			exit 3

		fi

		if [[ ! ${aux} ]]; then

			aux=1000

		fi

	done

	maxres=${aux}

fi

name=$(youtube-dl -e "${link}")

if [[ $? != 0 ]]; then

	exit 2;

fi

args='--allow-overwrite=true -c --file-allocation=none --log-level=error
-m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=0 -t5'

(

	sleep 0.2
	i3-msg move position mouse

) &

text="$(echo "${name}" | tr '&' 'y')\n${maxres}\n"

stdbuf -o0 youtube-dl -q --no-playlist -f "bestvideo[height<=?${maxres}]+bestaudio/best[height<=?${maxres}]/bestvideo+bestaudio/best" \
--exec "echo {} > ${tmp}/title" --external-downloader "aria2c" --external-downloader-args "${args}" \
-o "${tmp}/%(title)s-%(id)s.%(ext)s" "${link}" 2>&1 | tee -a "${tmp}"/ytlog | \
tee /dev/tty | grep --line-buffered -oP '^\[#.*?\K([0-9.]+\%)' | \
zenity --progress --title="Yt-dl-aria2c" --text="${text}" --percentage=0 --auto-close --no-cancel

if [[ $? != 0 ]]; then

	exit 4;

fi

youtube-dl --list-subs "${link}" &> "${tmp}/subs"

if grep -q "video doesn't have subtitles" "${tmp}/subs"; then

	rm "${tmp}/subs"

fi

title=$(cat "${tmp}"/title)

if [[ -f "${tmp}/subs" ]]; then

	rm "${tmp}/subs"

	youtube-dl -q --write-sub --skip-download \
	-o "${tmp}/%(title)s-ytsub-%(id)s.%(ext)s" "${link}"

	sub=$(ls "${tmp}" | grep -- -ytsub-)
	sub="${tmp}/${sub}"

fi

rm "${tmp}/title"

if [[ ${maxres} != "1000" ]]; then

	zenity --question --text="Descarga completa. Reproducir?" \
	--ok-label="Yup" --cancel-label="Nope"

fi

if [[ $? == 0 || ${maxres} == "1000" ]]; then

	wid=$(wmctrl -lx | awk '{print $1" "$2" "$3}' | grep "smtube.smtube" | awk '{print $1}')

	if [[ ${wid} ]]; then

		if [[ ${maxres} != 1000 ]]; then

			zenity --question --text="Unir a smtube?" \
			--ok-label="Yup" --cancel-label="Nope" && \
			wid="--wid=${wid}"

		else

			wid="--wid=${wid}"

		fi

	fi

	if [[ ${sub} ]]; then

		mpv --no-terminal "${wid}" --sub-file="${sub}" "${title}"

	else

		mpv --no-terminal "${wid}" "${title}"

	fi

	if [[ ${maxres} != "1000" ]]; then

		zenity --question --text="Guardar" \
		--ok-label="Yup" --cancel-label="Nope"

	fi

	if [[ $? != 0 || ${maxres} == "1000" ]]; then

		rm "${title}"

		if [[ ${sub} ]]; then

			rm "${sub}"

		fi

		exit 0

	fi

fi

if echo "${title: -4}" | grep -q -F "."; then

	ruta=$(zenity --file-selection --save --confirm-overwrite \
	--filename="${name}.${title: -3}");

else

	ruta=$(zenity --file-selection --save --confirm-overwrite \
	--filename="${name}.${title: -4}");

fi

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
