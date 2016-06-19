#!/bin/bash
#vim set lang spanglish

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

			if [[ ${currentvacio} == true ]]; then

				color="Escritorio"

			else

				color="Transparente"

			fi

		fi

	else

		color="Escritorio"

	fi

	if [[ ${color} != ${currentcolor} ]]; then

		head -n -18 .Dot/Laptop/i3/config > .barconfig

		mv .barconfig .config/i3/config

		case ${color} in

			Negro)

				echo '	status_command sh ~/.config/i3/i3status.sh "#16A085"'	>> ${config}
				echo "	colors {"												>> ${config}
				echo '	separator #16A085'										>> ${config}
				echo '	background #000000'										>> ${config}
				echo '	statusline #ffffff'										>> ${config}
				echo '	focused_workspace #16A085 #16A085 #ffffff'				>> ${config}
				echo '	active_workspace #454749 #454749 #ffffff'				>> ${config}
				echo '	inactive_workspace #000000 #000000 #ffffff'				>> ${config}
				echo '	urgent_workspace #900000 #900000 #ffffff'				>> ${config}
				echo "	}"														>> ${config}
				echo "}"														>> ${config}
				echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> ${config}
				echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> ${config}
				echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> ${config}

			;;

			Spotify)

				echo '	status_command sh ~/.config/i3/i3status.sh "#1ED660"'	>> ${config}
				echo "	colors {"												>> ${config}
				echo '	separator #1ED660'										>> ${config}
				echo '	background #282828'										>> ${config}
				echo '	statusline #ffffff'										>> ${config}
				echo '	focused_workspace #1ED660 #1ED660 #ffffff'				>> ${config}
				echo '	active_workspace #454749 #454749 #ffffff'				>> ${config}
				echo '	inactive_workspace #282828 #282828 #ffffff'				>> ${config}
				echo '	urgent_workspace #900000 #900000 #ffffff'				>> ${config}
				echo "	}"														>> ${config}
				echo "}"														>> ${config}
				echo 'client.focused #1ED660 #1ED660 #ffffff #1ED660'			>> ${config}
				echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> ${config}
				echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> ${config}

			;;

			Geany)

				echo '	status_command sh ~/.config/i3/i3status.sh "#3A4145"'	>> ${config}
				echo "	colors {"												>> ${config}
				echo '	separator #3A4145'										>> ${config}
				echo '	background #000000'										>> ${config}
				echo '	statusline #ffffff'										>> ${config}
				echo '	focused_workspace #3A4145 #3A4145 #ffffff'				>> ${config}
				echo '	active_workspace #454749 #454749 #ffffff'				>> ${config}
				echo '	inactive_workspace #000000 #000000 #ffffff'				>> ${config}
				echo '	urgent_workspace #900000 #900000 #ffffff'				>> ${config}
				echo "	}"														>> ${config}
				echo "}"														>> ${config}
				echo 'client.focused #3A4145 #3A4145 #ffffff #16A085'			>> ${config}
				echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> ${config}
				echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> ${config}

			;;

			Escritorio)

				echo '	status_command sh ~/.config/i3/i3status.sh "#16A085"'	>> ${config}
				echo "	colors {"												>> ${config}
				echo '	separator #16A085'										>> ${config}
				echo '	background #00000000'									>> ${config}
				echo '	statusline #ffffff'										>> ${config}
				echo '	focused_workspace #16A085 #16A085 #ffffff'				>> ${config}
				echo '	active_workspace #454749 #454749 #ffffff'				>> ${config}
				echo '	inactive_workspace #00000000 #00000000 #ffffff'			>> ${config}
				echo '	urgent_workspace #900000 #900000 #ffffff'				>> ${config}
				echo "	}"														>> ${config}
				echo "}"														>> ${config}
				echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> ${config}
				echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> ${config}
				echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> ${config}

			;;

			*) # Transparente

				echo '	status_command sh ~/.config/i3/i3status.sh "#16A085"'	>> ${config}
				echo "	colors {"												>> ${config}
				echo '	separator #16A085'										>> ${config}
				echo '	background #00000000'									>> ${config}
				echo '	statusline #ffffff'										>> ${config}
				echo '	focused_workspace #16A085 #16A085 #ffffff'				>> ${config}
				echo '	active_workspace #454749 #454749 #ffffff'				>> ${config}
				echo '	inactive_workspace #00000000 #00000000 #ffffff'			>> ${config}
				echo '	urgent_workspace #900000 #900000 #ffffff'				>> ${config}
				echo "	}"														>> ${config}
				echo "}"														>> ${config}
				echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> ${config}
				echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> ${config}
				echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> ${config}

			;;

		esac

		currentcolor=${color}

		i3-msg reload

	fi

	sleep 2

done

# barcolor <colorclass> <border> <background> <text>

# class    <border>  <backgr> <text> <indicator> <child_border>
