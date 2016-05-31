#!/bin/sh

ACTION=`zenity --width=90 --height=220 --list --radiolist --text="Que hago vieja?" --title="Salir" --column "Eleccion" --column "" TRUE Apagar FALSE Salir FALSE Reiniciar FALSE Suspender`

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
    sleep 1; systemctl suspend
    ;;
  esac
fi
