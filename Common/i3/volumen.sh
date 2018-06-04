#!/bin/bash

volInicial=$(pamixer --get-volume);
volAnterior=${volInicial}

zenity --scale --text="Nivel de Volumen?" --value=${volInicial} \
--max-value=100 --print-partial > .volumen &

sh_pid=$!

while ps -p ${sh_pid} > /dev/null; do
	volActual=$(tail -1 < .volumen)

	if [[ "${volActual}" != "${volAnterior}"  ]]; then
		pamixer --set-volume ${volActual}
		volAnterior=${volActual}
	fi

	sleep 0.5
done

rm .volumen
wait ${sh_pid}

if [[ $? != 0 ]]; then
	pamixer --set-volume ${volInicial}
fi
