#/bin/bash

cd POP;

while true; do

	Fecha=$(date '+%Y_%m_%d__%H_%M_%S');

	echo "Empiezo ${Fecha}";

	rtmpdump -i rtmp://popradio.stweb.tv:1935/popradio/live -o "${Fecha}.flv" -v -q;

	echo "Termine ${Fecha}";

done
