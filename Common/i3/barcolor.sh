#!/bin/bash
#vim set lang spanglish

if ! [[ -f ~.dotlaptop ]]; then

	host="Desktop"

else

	host="Laptop"

fi

config="${HOME}/.config/i3/config"
currentcolor=""

while true; do

	color=""

	arr=( $(wmctrl -lx | awk '{print $2}') )

	if [ ${#arr[@]} -gt 0 ]; then # Existe alguna ventana

		current=$(xprop -root | grep "DESKTOP(CARDINAL)" | tr -c -d "[:digit:]\n")

		currentvacio=true;

		for ar in "${arr[@]}"; do

			if [[ ${ar} -eq ${current} ]]; then

				currentvacio=false; # Hay por lo menos una ventana en el escritorio activo

				break

			fi

		done

		arr=( $(printf '%s\n' "${arr[@]}" | awk '!($0 in seen){seen[$0];next} 1') )

		multipleincurrent=false;

		if [[ ${currentvacio} == false && ${#arr[@]} -gt 0 ]]; then

			for ar in "${arr[@]}"; do

				if [[ ${ar} -eq ${current} ]]; then

					multipleincurrent=true;

					break

				fi

			done

		fi

		if [[ ${currentvacio} == false && ${multipleincurrent} == false ]]; then

			known=( 'Spotify' 'Geany' )

			active=$(sleep 2; xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) WM_CLASS)

			for know in "${known[@]}"; do

				if echo "${active}" | grep -q ${know}; then

					color=${know}

					break

				fi

			done

			if [[ ! ${color} ]]; then

				color="Negro"

			fi

		else

			color="Transparente"

		fi

	else

		color="Transparente"

	fi

	if [[ ${color} != ${currentcolor} ]]; then

		head -n -14 .Dot/${host}/i3/config > .barconfig

		mv .barconfig .config/i3/config

		case ${color} in

			Negro)

				echo "# Foco"						>> ${config}
				echo 'set $color #16A085'			>> ${config}
				echo "# Sin Foco"					>> ${config}
				echo 'set $color2 #454749'			>> ${config}
				echo "# Foco en Espacio sin foco"	>> ${config}
				echo 'set $color3 #353638'			>> ${config}
				echo "# Texto"						>> ${config}
				echo 'set $blanco #ffffff'			>> ${config}
				echo "# Inactivo"					>> ${config}
				echo 'set $negro #000000'			>> ${config}
				echo "# Urgente"					>> ${config}
				echo 'set $rojo #900000'			>> ${config}
				echo "# Fondo"						>> ${config}
				echo 'set $transparente #000000'	>> ${config}

			;;

			Spotify)

				echo "# Foco"						>> ${config}
				echo 'set $color #1ED660'			>> ${config}
				echo "# Sin Foco"					>> ${config}
				echo 'set $color2 #454749'			>> ${config}
				echo "# Foco en Espacio sin foco"	>> ${config}
				echo 'set $color3 #353638'			>> ${config}
				echo "# Texto"						>> ${config}
				echo 'set $blanco #ffffff'			>> ${config}
				echo "# Inactivo"					>> ${config}
				echo 'set $negro #000000'			>> ${config}
				echo "# Urgente"					>> ${config}
				echo 'set $rojo #900000'			>> ${config}
				echo "# Fondo"						>> ${config}
				echo 'set $transparente #282828'	>> ${config}

			;;

			Geany)

				echo "# Foco"						>> ${config}
				echo 'set $color #3A4145'			>> ${config}
				echo "# Sin Foco"					>> ${config}
				echo 'set $color2 #454749'			>> ${config}
				echo "# Foco en Espacio sin foco"	>> ${config}
				echo 'set $color3 #353638'			>> ${config}
				echo "# Texto"						>> ${config}
				echo 'set $blanco #ffffff'			>> ${config}
				echo "# Inactivo"					>> ${config}
				echo 'set $negro #000000'			>> ${config}
				echo "# Urgente"					>> ${config}
				echo 'set $rojo #900000'			>> ${config}
				echo "# Fondo"						>> ${config}
				echo 'set $transparente #000000'	>> ${config}

			;;

			*) # Transparente

				echo "# Foco"						>> ${config}
				echo 'set $color #16A085'			>> ${config}
				echo "# Sin Foco"					>> ${config}
				echo 'set $color2 #454749'			>> ${config}
				echo "# Foco en Espacio sin foco"	>> ${config}
				echo 'set $color3 #353638'			>> ${config}
				echo "# Texto"						>> ${config}
				echo 'set $blanco #ffffff'			>> ${config}
				echo "# Inactivo"					>> ${config}
				echo 'set $negro #000000'			>> ${config}
				echo "# Urgente"					>> ${config}
				echo 'set $rojo #900000'			>> ${config}
				echo "# Fondo"						>> ${config}
				echo 'set $transparente #00000000'	>> ${config}

			;;

		esac

		currentcolor=${color}

		i3-msg reload

	fi

	sleep 2

done
