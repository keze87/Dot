#!/bin/bash

if systemctl is-active --quiet sshd.service; then

	systemctl stop sshd.service && \
	zenity --warning --text="SSHD inactivo"

else

	systemctl start sshd.service && \
	zenity --warning --text="SSHD activo\n$(ifconfig | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")"

fi
