#!/bin/bash

if systemctl is-active --quiet sshd.service; then

	systemctl stop sshd.service && kdialog --msgbox "SSHD inactivo"

else

	default_iface=$(awk '$2 == 00000000 { print $1 }' /proc/net/route)
	ip=$(ip addr show dev "${default_iface}" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')

	systemctl start sshd.service && kdialog --msgbox "SSHD activo:\n\n${ip}"

fi
