#!/bin/bash

# dialog rsync pygmentize expac rtmpdump
# youtube-dl aria2c mpv wmctrl FontAwesome rsstail

dir=~/.Dot
olddir=~/Dot_Old

### Menu ###

menu=$(dialog --clear --output-fd 1 \
			  --backtitle "Keze87 DotFiles" \
			  --title "Instalación" \
			  --menu "Selecciona la configuracion a instalar,\n\
dependiendo del tamaño de pantalla." 10 50 2 \
			  Desktop "24 Pulgadas" \
			  Laptop "13 Pulgadas" \
			  Termux "5 Pulgadas")

if [[ $? == 0 ]]; then

	if [[ -f ~/.dotlaptop ]]; then

		rm ~/.dotlaptop

	fi

	if [ -d "${olddir}" ]; then

		gvfs-trash "${olddir}"

	fi

	mkdir "${olddir}"

	case $menu in

		Desktop)

			bash "${dir}"/Common/Common.sh

			bash "${dir}"/Desktop/Desktop.sh

		;;

		Laptop)

			bash "${dir}"/Common/Common.sh

			bash "${dir}"/Laptop/Laptop.sh

			touch ~/.dotlaptop

		;;

		Termux)

			bash "${dir}"/Termux/Termux.sh

		;;

	esac

fi

clear
