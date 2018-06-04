#!/bin/bash

moverACursor(){

	(

		sleep 0.2
		i3-msg move position mouse > /dev/null

	) &

	"$@"

	return $?

}

if [[ $2 ]]; then

	link=$2;

	if [[ $1 == *[[:digit:]]* && $1 -le 9999 ]]; then #$1 numero?

		maxres=$1;

	else

		exit 1;

	fi

else

	if [[ $1 ]]; then

		if [[ $1 == *[[:digit:]]* && $1 -le 9999 ]]; then #$1 numero?

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

if [[ ! "${link}" ]]; then

	exit 2

fi

echo "${link}"

tmp=~/.cache

if [[ -f "${tmp}"/ytlog ]]; then

	rm "${tmp}"/ytlog

fi

touch "${tmp}"/ytlog

if [[ ${maxres} == 1000 ]]; then

	aux="aux"

	while [[ ${aux} != *[[:digit:]]* ]] ; do

		aux=$(kdialog --radiolist "${link}<br>Resolucion?" "600" "SD" off "1000" "HD" on \
"1100" "FHD" off "9000" "8K" off)

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

args='--allow-overwrite=true -c --file-allocation=none -m2 -x8
--max-file-not-found=5 --no-conf -Rtrue --summary-interval=0 -t5'

text="$(echo "${name}" | tr '&' 'y')"

dbusRef=$(moverACursor kdialog --progressbar "${text}<br>[R:${maxres}]" 100 2>/dev/null)
dbusRef=${dbusRef%" /ProgressDialog"}
qdbus "${dbusRef}" /ProgressDialog showCancelButton true &> /dev/null

(

stdbuf -o0 youtube-dl -q --no-playlist -f \
"bestvideo[height<=?${maxres}]+bestaudio/best[height<=?${maxres}]/bestvideo+bestaudio/best" \
--exec "echo {} > ${tmp}/title" --external-downloader "aria2c" \
--external-downloader-args "${args}" \
-o "${tmp}/%(title)s-%(id)s.%(ext)s" "${link}" &> "${tmp}"/ytlog

) &

while jobs %% &> /dev/null; do

	sleep 0.5

	textoProgreso=""
	progreso=""

	textoProgreso=$(grep -F '[#' "${tmp}"/ytlog | tail -n 1 | awk '{print $2" "$3" "$4" "$5}')

	if [[ ${textoProgreso} ]]; then

		qdbus "${dbusRef}" /ProgressDialog setLabelText "${text}<br>[R:${maxres} ${textoProgreso}" &> /dev/null

		progreso=$(echo "${textoProgreso}" | grep -oP '.*?\K([0-9.]+\%)' | tr -d '%')

		if [[ ${progreso} ]]; then

			qdbus "${dbusRef}" /ProgressDialog Set "" "value" "${progreso}" &> /dev/null

		fi

	fi

	if ! qdbus "${dbusRef}" /ProgressDialog &> /dev/null; then

		#pkill -P $$
		kill "$(jobs -p)"
		exit 10

	fi

done

qdbus "${dbusRef}" /ProgressDialog setLabelText "Buscando Subtitulos" &> /dev/null
qdbus "${dbusRef}" /ProgressDialog Set "" "value" 99 &> /dev/null

youtube-dl --list-subs "${link}" &> "${tmp}/subs"

if grep -q -E "video doesn't have subtitles|has no subtitles" "${tmp}/subs"; then

	rm "${tmp}/subs"

fi

title=$(cat "${tmp}"/title)

rm "${tmp}/title"

if [[ -f "${tmp}/subs" ]]; then

	rm "${tmp}/subs"

	youtube-dl -q --write-sub --skip-download \
	-o "${tmp}/%(title)s-ytsub-%(id)s.%(ext)s" "${link}"

	sub=$(ls "${tmp}" | grep -- -ytsub-)
	sub="${tmp}/${sub}"

fi

qdbus "${dbusRef}" /ProgressDialog close &> /dev/null

if [[ ${maxres} != "1000" ]]; then

	moverACursor kdialog --title "Reproducir?" --yesno "Descarga completa. Reproducir?" &> /dev/null

fi

if [[ $? == 0 || ${maxres} == "1000" ]]; then

	wid=$(wmctrl -lx | awk '{print $1" "$3}' | grep "smtube.smtube" | awk '{print $1}')

	if [[ ${wid} ]]; then

		if [[ ${maxres} != 1000 ]]; then

			if moverACursor kdialog --title "smtube?" --yesno "Unir a smtube?" &> /dev/null; then

				wid="--wid=${wid}"

			else

				wid=""

			fi

		else

			wid="--wid=${wid}"

		fi

	fi

	if [[ ${sub} ]]; then

		mpv ${wid} --sub-file="${sub}" "${title}"

	else

		mpv ${wid} "${title}"

	fi

	if [[ ${maxres} != "1000" ]]; then

		moverACursor kdialog --title "Guardar?" --yesno "Guardar?" &> /dev/null

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

	ruta=$(moverACursor kdialog --getsavefilename "${HOME}/${name}.${title: -3}" 2>/dev/null);

else

	ruta=$(moverACursor kdialog --getsavefilename "${HOME}/${name}.${title: -4}" 2>/dev/null);

fi

if [[ ${ruta} ]]; then

	mv "${title}" "${ruta}"

	if [[ ${sub} ]]; then

		mv "${sub}" "${ruta::-4}.${sub: -3}"

	fi

else

	gio trash "${title}"

	if [[ ${sub} ]]; then

		gio trash "${sub}"

	fi

	echo "Queda en papelera"

fi
