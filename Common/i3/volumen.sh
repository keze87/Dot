#!/bin/bash

volumen=$(amixer get Master | grep Right: | awk '{print $4}');
volumenmax=$(amixer get Master | grep Limits | awk '{print $5}');

zenity --scale --text="Nivel de Volumen?" --value=${volumen} \
--max-value=${volumenmax} --hide-value --print-partial > .volumen &

sh_pid=$!

tmp2="70000"

while ps -p ${sh_pid} > /dev/null; do

	tmp=$(tail -1 < .volumen)

	if [[ ${tmp} ]]; then

		if [[ "${tmp}" != "${tmp2}"  ]]; then

			amixer set Master ${tmp}

		fi

		tmp2=${tmp}

	fi

	sleep 0.5

done

rm .volumen

wait ${sh_pid}

if [[ $? != 0 ]]; then

	amixer set Master ${volumen}

fi
