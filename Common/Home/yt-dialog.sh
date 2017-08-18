#!/bin/bash

if which xclip; then

	down="xclip -o"

else

	down="termux-clipboard-get"

fi

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

			link=$($down);

		else

			link=$1

			maxres=1080

		fi

	else

		link=$($down);

		maxres=1080

	fi

fi

if [[ ! ${link} ]]; then

	exit 1

fi

if uname -a | grep -q arm ; then

	tmp=~/storage/shared/Movies

else

	tmp=~/.cache

fi

if [[ ${maxres} == 1000 ]]; then

	aux="aux"

	while [[ ${aux} != *[[:digit:]]* ]] ; do

		aux=$(dialog --inputbox "${link}\nResolucion?" 25 25  --output-fd 1)

		if [[ $? != 0 ]]; then

			exit 3

		fi

		if [[ ! ${aux} ]]; then

			aux=1000

		fi

	done

	maxres=${aux}

fi

if [[ $? != 0 ]]; then

	exit 2;

fi

args='--allow-overwrite=true -c --file-allocation=none --log-level=error
-m2 -x8 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=0 -t5'

if [[ ${maxres} == 0 ]]; then

	youtube-dl -q --no-playlist -f "bestvideo+bestaudio/best" --exec "echo {} > ${tmp}/title" \
	--external-downloader "aria2c" --external-downloader-args "${args}" \
	-o "${tmp}/%(title)s-%(id)s.%(ext)s" "${link}"

else

	youtube-dl -q --no-playlist -f "bestvideo[height<=?${maxres}]+bestaudio/best[height<=?${maxres}]/best" \
	--exec "echo {} > ${tmp}/title" --external-downloader "aria2c" --external-downloader-args "${args}" \
	-o "${tmp}/%(title)s-%(id)s.%(ext)s" "${link}"

fi

if [[ $? != 0 ]]; then

	exit 4;

else

	echo "Guardado en ${tmp}"

fi

youtube-dl --list-subs "${link}" &> "${tmp}/subs"

if grep -q "video doesn't have subtitles" "${tmp}/subs"; then

	rm "${tmp}/subs"

fi

if [[ -f "${tmp}/subs" ]]; then

	rm "${tmp}/subs"

	youtube-dl -q --write-sub --skip-download \
	-o "${tmp}/%(title)s-ytsub-%(id)s.%(ext)s" "${link}"

	sub=$(ls "${tmp}" | grep -- -ytsub-)
	sub="${tmp}/${sub}"

fi

rm "${tmp}/title"
