#!/bin/bash

ACTION=$(zenity --width=90 --height=244 --list --radiolist --text="Que hago vieja?" \
--title="Salir" --column "Eleccion" --column "" \
TRUE Apagar FALSE Salir FALSE Reiniciar FALSE Suspender FALSE Apagar\ monitor)

if [ -n "${ACTION}" ];then

	case $ACTION in

		Apagar)

			systemctl poweroff

		;;

		Salir)

			i3-msg exit

		;;

		Reiniciar)

			systemctl reboot

		;;

		Suspender)

			sleep 1
			systemctl suspend

		;;

		Apagar\ monitor)

			sleep 1
			xset dpms force off

		;;

	esac

fi
