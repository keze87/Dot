#/bin/bash

if [[ -d "/tmp/POP" ]]; then

	cd "/tmp/POP" || exit 1

else

	mkdir "/tmp/POP"

	cd "/tmp/POP" || exit 2

fi

while true; do

	Fecha=$(date '+%Y_%m_%d__%H_%M_%S');

	echo "Empiezo ${Fecha}";

	rtmpdump -i rtmp://popradio.stweb.tv:1935/popradio/live -o "${Fecha}.flv" -v -q;

	echo "Termine ${Fecha}";

done
