#!/bin/bash
#vim set lang spanglish

if [[ $1 ]]; then

	host=$1;

else

	host="Desktop";

fi

config="${HOME}/.config/i3/config"
currentcolor=""
ids2=( '#nerfed' )

while true; do

	current=$(xprop -root _NET_CURRENT_DESKTOP | tr -c -d "[:digit:]\n")

	ids=( $(wmctrl -lx | awk '{print $1" "$2}' | grep " ${current}" | awk '{print $1}') )

	if [[ "${ids[*]}" != "${ids2[*]}" ]]; then

		ids2=( "${ids[@]}" )

		color=""

		arr=( $(wmctrl -lx | awk '{print $1" "$2}' | grep " ${current}" | awk '{print $2}') )

		if [ ${#arr[@]} -gt 0 ]; then # Existe alguna ventana en current

			arr=( $(printf '%s\n' "${arr[@]}" | awk '!($0 in seen){seen[$0];next} 1') )

			multipleincurrent=false;

			if [[ ${#arr[@]} -gt 0 ]]; then

				normal=0

				for ar in "${arr[@]}"; do

					if [[ ${ar} -eq ${current} ]]; then

						for id in "${ids[@]}"; do

							xprop -id "${id}" | grep "NET_WM_WINDOW_TYPE" | grep "= _NET_WM_WINDOW_TYPE_NORMAL"

							if [[ $? != 0 ]]; then

								xprop -id "${id}" | grep "WM_CLASS" | grep "Spotify"

								if [[ $? != 0 ]]; then

									xprop -id "${id}" | grep "WM_CLASS" | grep "mpv"

								fi

							fi

							if [[ $? == 0 ]]; then

								normal=$((normal + 1))

								if [[ ${normal} -gt 1 ]]; then

									multipleincurrent=true

									break

								fi

							fi

						done

					fi

				done

			fi

			if [[ ${multipleincurrent} == false ]]; then

				known=( 'Spotify' 'Geany' 'Terminator' 'guake' 'albert' 'zenity' )

				active=$(xprop -id "$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)" WM_CLASS)

				for know in "${known[@]}"; do

					if echo "${active}" | grep -q "${know}"; then

						color=${know}

						break

					fi

				done

				if [[ ${color} == "guake" || ${color} == "albert" || ${color} == "zenity" ]]; then

					color=${currentcolor}

				fi

				if [[ ! ${color} ]]; then

					color="Negro"

				fi

			else

				if [[ ${#arr[@]} -eq 0 ]]; then

					color="Escritorio${host}"

				else

					color="Transparente"

				fi

			fi

		else

			color="Escritorio${host}"

		fi

		if [[ ${color} != "${currentcolor}" ]]; then

			head -n -1 .Dot/${host}/i3/config > .barconfig

			mv .barconfig .config/i3/config

			case ${color} in

				Negro)

					echo -e "	colors {\n"											>> "${config}"
					echo '		separator #16A085'									>> "${config}"
					echo '		background #000000'									>> "${config}"
					echo '		statusline #ffffff'									>> "${config}"
					echo '		focused_workspace #16A085 #16A085 #ffffff'			>> "${config}"
					echo '		active_workspace #454749 #454749 #ffffff'			>> "${config}"
					echo '		inactive_workspace #000000 #000000 #ffffff'			>> "${config}"
					echo '		urgent_workspace #900000 #900000 #ffffff'			>> "${config}"
					echo -e "\n	}\n"												>> "${config}"
					echo -e "}\n"													>> "${config}"
					echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> "${config}"
					echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> "${config}"
					echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> "${config}"
					echo '#16A085'													>> "${config}"

				;;

				Spotify)

					echo -e "	colors {\n"											>> "${config}"
					echo '		separator #1ED660'									>> "${config}"
					echo '		background #282828'									>> "${config}"
					echo '		statusline #ffffff'									>> "${config}"
					echo '		focused_workspace #1ED660 #1ED660 #ffffff'			>> "${config}"
					echo '		active_workspace #454749 #454749 #ffffff'			>> "${config}"
					echo '		inactive_workspace #282828 #282828 #ffffff'			>> "${config}"
					echo '		urgent_workspace #900000 #900000 #ffffff'			>> "${config}"
					echo -e "\n	}\n"												>> "${config}"
					echo -e "}\n"													>> "${config}"
					echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> "${config}"
					echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> "${config}"
					echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> "${config}"
					echo '#1ED660'													>> "${config}"

				;;

				Geany)

					echo -e "	colors {\n"											>> "${config}"
					echo '		separator #8AE234'									>> "${config}"
					echo '		background #454749'									>> "${config}"
					echo '		statusline #ffffff'									>> "${config}"
					echo '		focused_workspace #8AE234 #8AE234 #ffffff'			>> "${config}"
					echo '		active_workspace #454749 #454749 #ffffff'			>> "${config}"
					echo '		inactive_workspace #454749 #454749 #ffffff'			>> "${config}"
					echo '		urgent_workspace #900000 #900000 #ffffff'			>> "${config}"
					echo -e "\n	}\n"												>> "${config}"
					echo -e "}\n"													>> "${config}"
					echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> "${config}"
					echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> "${config}"
					echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> "${config}"
					echo '#8AE234'													>> "${config}"

				;;

				Terminator)

					echo -e "	colors {\n"											>> "${config}"
					echo '		separator #8AE234'									>> "${config}"
					echo '		background #000000CC'								>> "${config}"
					echo '		statusline #ffffff'									>> "${config}"
					echo '		focused_workspace #8AE234 #8AE234 #ffffff'			>> "${config}"
					echo '		active_workspace #454749 #454749 #ffffff'			>> "${config}"
					echo '		inactive_workspace #000000CC #000000CC #ffffff'		>> "${config}"
					echo '		urgent_workspace #900000 #900000 #ffffff'			>> "${config}"
					echo -e "\n	}\n"												>> "${config}"
					echo -e "}\n"													>> "${config}"
					echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> "${config}"
					echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> "${config}"
					echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> "${config}"
					echo '#8AE234'													>> "${config}"

				;;

				EscritorioDesktop)

					echo -e "	colors {\n"											>> "${config}"
					echo '		separator #16A085'									>> "${config}"
					echo '		background #00000000'								>> "${config}"
					echo '		statusline #ffffff'									>> "${config}"
					echo '		focused_workspace #16A085 #16A085 #ffffff'			>> "${config}"
					echo '		active_workspace #454749 #454749 #ffffff'			>> "${config}"
					echo '		inactive_workspace #00000000 #00000000 #ffffff'		>> "${config}"
					echo '		urgent_workspace #900000 #900000 #ffffff'			>> "${config}"
					echo -e "\n	}\n"												>> "${config}"
					echo -e "}\n"													>> "${config}"
					echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> "${config}"
					echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> "${config}"
					echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> "${config}"
					echo '#16A085'													>> "${config}"

				;;

				EscritorioLaptop)

					echo -e "	colors {\n"											>> "${config}"
					echo '		separator #ED1A5F'									>> "${config}"
					echo '		background #00000000'								>> "${config}"
					echo '		statusline #ffffff'									>> "${config}"
					echo '		focused_workspace #ED1A5F #ED1A5F #ffffff'			>> "${config}"
					echo '		active_workspace #454749 #454749 #ffffff'			>> "${config}"
					echo '		inactive_workspace #00000000 #00000000 #ffffff'		>> "${config}"
					echo '		urgent_workspace #900000 #900000 #ffffff'			>> "${config}"
					echo -e "\n	}\n"												>> "${config}"
					echo -e "}\n"													>> "${config}"
					echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> "${config}"
					echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> "${config}"
					echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> "${config}"
					echo '#1C0C26'													>> "${config}"

				;;

				*) # Transparente

					echo -e "	colors {\n"											>> "${config}"
					echo '		separator #16A085'									>> "${config}"
					echo '		background #00000000'								>> "${config}"
					echo '		statusline #ffffff'									>> "${config}"
					echo '		focused_workspace #16A085 #16A085 #ffffff'			>> "${config}"
					echo '		active_workspace #454749 #454749 #ffffff'			>> "${config}"
					echo '		inactive_workspace #00000000 #00000000 #ffffff'		>> "${config}"
					echo '		urgent_workspace #900000 #900000 #ffffff'			>> "${config}"
					echo -e "\n	}\n"												>> "${config}"
					echo -e "}\n"													>> "${config}"
					echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> "${config}"
					echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> "${config}"
					echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> "${config}"
					echo '#16A085'													>> "${config}"

				;;

			esac

			currentcolor=${color}

			i3-msg reload

		fi

	fi

	sleep 2

done

# barcolor <colorclass> <border> <background> <text>

# class    <border>  <backgr> <text> <indicator> <child_border>

# <separator>
