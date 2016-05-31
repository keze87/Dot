#!/bin/bash

if ps -fC zenity | grep -q olumen; then

	exit

fi

volumen=$(amixer get Master | grep Right: | awk {"print \$4"});

sh -c '

	volumenmax=$(amixer get Master | grep Limits | awk {"print \$5"});
	volumen=$(amixer get Master | grep Right: | awk {"print \$4"});

	zenity --scale --text="Nivel de Volumen?" --value=$volumen --max-value=$volumenmax --hide-value --print-partial > .volumen

	exit $?

'&

sh_pid=$!

tmp2="70000"

while ps -p $sh_pid > /dev/null; do

	tmp=$(cat .volumen | tail -1)

	if [[ $tmp ]]; then

		if [[ $tmp != $tmp2  ]]; then

			amixer set Master $tmp

		fi

		tmp2=$tmp

	fi

	sleep 0.5

done

rm .volumen

wait $sh_pid

if [[ $? != 0 ]]; then

	amixer set Master $volumen

fi
