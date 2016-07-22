#!/bin/bash
#vim set lang spanglish

if [[ $1 ]]; then

	host=$1;

else

	host="Desktop";

fi

config="${HOME}/.config/i3/config"
currentcolor="Negro"

known=( 'spotify' 'geany' 'audacious' 'terminator' 'guake' 'albert' 'zenity' )

### tamaño pantalla
if [[ ${host} == 'Desktop' ]]; then

	x=1900
	y=1000

else

	x=1300
	y=700

fi

### Separacion de array
IFS=$'\n'

while true; do

	active=$(xprop -id "$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | \
	cut -f 2)" WM_CLASS | awk '{print $3}' | tr -c -d '[:alnum:]\n')

	current=$(xprop -root _NET_CURRENT_DESKTOP | tr -c -d "[:digit:]\n")

	ids=( $(wmctrl -lx | awk '{print $1" "$2}' | grep " ${current}" | awk '{print $1}') )

	multipleincurrent=true

	wmc=( $(wmctrl -lG | awk '{print $1" work:"$2" "$5" "$6}' | grep "work:${current}") )

	for id in "${ids[@]}"; do

		for wm in "${wmc[@]}"; do

			if echo ${wm} | grep -q ${id}; then

				horizontal=$(echo ${wmc} | awk '{print $3}')
				vertical=$(echo ${wmc} | awk '{print $4}')

				if [[ ${horizontal} -gt ${x} && ${vertical} -gt ${y} ]]; then

					multipleincurrent=false

				fi

				break

			fi

		done

		if [[ ${multipleincurrent} == false ]]; then

			break

		fi

	done

	if [[ ${multipleincurrent} == false ]]; then

		color=''

		for know in "${known[@]}"; do

			if [[ "${active}" == "${know}" ]]; then

				color=${know}

				break

			fi

		done

		if [[ ! ${color} ]]; then

			color="Negro"

		else

			if [[ ${color} == "guake" || ${color} == "audacious" || ${color} == "albert" || ${color} == "zenity" ]]; then

				color=${currentcolor}

			fi

		fi

	else

		if [[ ${#ids[@]} -eq 0 ]]; then

			color="Escritorio${host}"

		else

			color="Transparente"

		fi

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

			spotify)

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

			geany)

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

			terminator)

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
				echo '		separator #45C0EA'									>> "${config}"
				echo '		background #00000000'								>> "${config}"
				echo '		statusline #ffffff'									>> "${config}"
				echo '		focused_workspace #45C0EA #45C0EA #ffffff'			>> "${config}"
				echo '		active_workspace #454749 #454749 #ffffff'			>> "${config}"
				echo '		inactive_workspace #00000000 #00000000 #ffffff'		>> "${config}"
				echo '		urgent_workspace #900000 #900000 #ffffff'			>> "${config}"
				echo -e "\n	}\n"												>> "${config}"
				echo -e "}\n"													>> "${config}"
				echo 'client.focused #16A085 #16A085 #ffffff #16A085'			>> "${config}"
				echo 'client.focused_inactive #353638 #353638 #ffffff #454749'	>> "${config}"
				echo 'client.unfocused #454749 #454749 #ffffff #454749'			>> "${config}"
				echo '#45C0EA'													>> "${config}"

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
				echo '#ED1A5F'													>> "${config}"

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

	sleep 2

done

# barcolor <colorclass> <border> <background> <text>

# class    <border> <backgr> <text> <indicator> <child_border>

# <separator>
