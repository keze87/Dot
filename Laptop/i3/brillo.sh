#!/bin/bash

if pgrep -a zenity | grep -q Brillo; then

	exit

fi

brillo=$(cat /sys/class/backlight/intel_backlight/actual_brightness);
brillomax=$(cat /sys/class/backlight/intel_backlight/max_brightness);

zenity --scale --text="Nivel de Brillo?" --value=${brillo} \
--max-value=${brillomax} --hide-value --print-partial > .brillo &

sh_pid=$!

tmp2="1000" # Para comparar y no volver a escribir el mismo valor

while ps -p ${sh_pid} > /dev/null; do

	tmp=$(tail -1 < .brillo)

	if [[ ${tmp} ]]; then

		if [[ "${tmp}" != "${tmp2}"  ]]; then

			echo "${tmp}" | tee /sys/class/backlight/*/brightness

		fi

		tmp2=${tmp}

	fi

	sleep 0.5

done

rm .brillo

wait ${sh_pid}

if [[ $? != 0 ]]; then

	echo  "${brillo}" | tee /sys/class/backlight/*/brightness

fi
