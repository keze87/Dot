#!bin/sh

if [ "$(pidof kvkbd | wc -w)" = 0 ]; then

	kvkbd

else

	killall kvkbd

fi
