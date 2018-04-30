#!/bin/bash

ACTION=$(kdialog --radiolist "Que hago vieja?" "Apagar" "Apagar" on "Cerrar Seccion" "Cerrar Seccion" \
off "Reiniciar" "Reiniciar" off "Suspender" "Suspender" off "Apagar monitor" "Apagar monitor" off)

if [ -n "${ACTION}" ];then

	case $ACTION in

		Apagar)

			systemctl poweroff

		;;

		Cerrar\ Seccion)

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
