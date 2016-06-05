#!/bin/bash

#set -x

# dialog rsync pygmentize expac rtmpdump
# youtube-dl aria2c mpv

dir="${HOME}/.Dot"
olddir="${HOME}/Dot_Old"

### Menu ###

menu=$(dialog --clear --output-fd 1 \
			  --backtitle "Keze87 DotFiles" \
			  --title "Instalación" \
			  --menu "Selecciona la configuracion a instalar,\n\
dependiendo del tamaño de pantalla." 10 50 2 \
			  Desktop "24 Pulgadas" \
			  Laptop "13 Pulgadas")

if [[ $? == 0 ]]; then

	if [ -d "${olddir}" ]; then

		gvfs-trash "${olddir}"

	fi

	mkdir "${olddir}"

	sh "${dir}"/Common/Common.sh

	case $menu in

		Desktop)

			sh "${dir}"/Desktop/Desktop.sh

		;;

		Laptop)

			sh "${dir}"/Laptop/Laptop.sh

		;;

	esac

fi

clear
