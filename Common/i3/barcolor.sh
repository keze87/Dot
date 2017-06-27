#!/bin/bash
#vim set lang spanglish

if [[ -f ~/.dotlaptop ]]; then

	host='Laptop';

else

	host='Desktop';

fi

config=~/.config/i3/config
currentcolor='#nerfed'

known=( 'spotify' 'geany' 'terminator' )

### tamaño pantalla
xChico=1200
yChico=700

xGrande=1880
yGrande=1040

x=${xGrande}
y=${yGrande}

# me fijo si hay un solo monitor {
cantMonitor=1

if [[ ${host} == 'Desktop' ]]; then

	if nvidia-settings --query CurrentMetaMode | grep -q -- "DPY-2"; then

		x=${xChico}
		y=${yChico}

		cantMonitor=2

	else

		x=${xGrande}
		y=${yGrande}

		cantMonitor=1

	fi

fi
#	}

### Separacion de array
IFS=$'\n'

while true; do

	current=$(xprop -root _NET_CURRENT_DESKTOP | tr -c -d "[:digit:]\n")

	wmctrl=$(wmctrl -lG | awk '{print $1" work:"$2" "$5" "$6}')

	ids=( $(echo "${wmctrl}" | grep "work:${current}" | awk '{print $1}') )

	wmc=( $(echo "${wmctrl}" | grep "work:${current}") )

	maximizedInCurrent=true

	for id in "${ids[@]}"; do

		for wm in "${wmc[@]}"; do

			if echo "${wm}" | grep -q "${id}"; then

				horizontal=$(echo "${wm}" | awk '{print $3}')
				vertical=$(echo "${wm}" | awk '{print $4}')

				if [[ ${horizontal} -gt ${x} && ${vertical} -gt ${y} ]]; then

					maximizedInCurrent=false

				fi

				break

			fi

		done

		if [[ ${maximizedInCurrent} == false ]]; then

			break

		fi

	done

	if [[ ${maximizedInCurrent} == false ]]; then

		color=''

		pidactive=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)

		active=$(xprop -id "${pidactive}" WM_CLASS | awk '{print $3}' | tr -c -d '[:alnum:]\n')

		for know in "${known[@]}"; do

			if [[ "${active}" == "${know}" ]]; then

				color=${know}

				break

			fi

		done

		wmc2=$(echo "${wmctrl}" | grep "${pidactive:2}")

		horizontal=$(echo "${wmc2}" | awk '{print $3}')
		vertical=$(echo "${wmc2}" | awk '{print $4}')

		if [[ ${horizontal} -lt ${x} || ${vertical} -lt ${y} ]]; then

			color=${currentcolor}

			if [[ ${color} == 'Transparente' ]]; then

				color="Negro"

			fi

		fi

		if [[ ! ${color} ]]; then

			color="Negro"

		fi

	else

		if [[ ${#ids[@]} -eq 0 ]]; then

			color="Escritorio${host}"

		else

			color='Transparente'

		fi

	fi

	if [[ ${color} != "${currentcolor}" ]]; then

		rm .barconfig

		cat .Dot/${host}/i3/config .Dot/Common/i3/config > .barconfig

		head -n -1 .barconfig > "${config}"

		if [[ ${cantMonitor} == 2 ]]; then

			if [[ ${color} == 'Transparente' || ${color} == 'EscritorioDesktop' ]]; then

				color='Negro'

			fi

		fi

		case ${color} in

			Negro)

				echo '
					colors {
						separator #4AAEE8
						background #000000
						statusline #ffffff
						focused_workspace #4AAEE8 #4AAEE8 #ffffff
						active_workspace #2C3133 #2C3133 #ffffff
						inactive_workspace #000000 #000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #4AAEE8 #4AAEE8 #ffffff #4AAEE8
				client.focused_inactive #353638 #353638 #ffffff #2C3133
				client.unfocused #2C3133 #2C3133 #ffffff #2C3133
				#4AAEE8'	>> "${config}"

			;;

			spotify)

				echo '
					colors {
						separator #1DB954
						background #121212
						statusline #ffffff
						focused_workspace #1DB954 #1DB954 #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #121212 #121212 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #1DB954 #1DB954 #ffffff #1DB954
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #121212 #121212 #ffffff #454749
				#1ED660'	>> "${config}"

			;;

			geany)

				echo '
					colors {
						separator #4AAEE8
						background #33393B
						statusline #ffffff
						focused_workspace #4AAEE8 #4AAEE8 #ffffff
						active_workspace #33393B #33393B #ffffff
						inactive_workspace #33393B #33393B #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #4AAEE8 #4AAEE8 #ffffff #4AAEE8
				client.focused_inactive #353638 #353638 #ffffff #33393B
				client.unfocused #33393B #33393B #ffffff #33393B
				#4AAEE8'	>> "${config}"

			;;

			terminator)

				echo '
					colors {
						separator #8AE234
						background #000000CC
						statusline #ffffff
						focused_workspace #8AE234 #8AE234 #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #000000CC #000000CC #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #8AE234 #8AE234 #ffffff #8AE234
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#8AE234'	>> "${config}"

			;;

			EscritorioDesktop)

				echo '
					colors {
						separator #3A6E3D
						background #00000000
						statusline #ffffff
						focused_workspace #3A6E3D #3A6E3D #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #00000000 #00000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #16A085 #16A085 #ffffff #16A085
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#3A6E3D'	>> "${config}"

			;;

			EscritorioLaptop)

				echo '
					colors {
						separator #FB574D
						background #00000000
						statusline #ffffff
						focused_workspace #FB574D #FB574D #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #00000000 #00000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #16A085 #16A085 #ffffff #16A085
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#FB574D'	>> "${config}"

			;;

			*) # Transparente

				echo '
					colors {
						separator #215D9C
						background #00000000
						statusline #ffffff
						focused_workspace #215D9C #215D9C #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #00000000 #00000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #215D9C #215D9C #ffffff #215D9C
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#215D9C'	>> "${config}"

			;;

		esac

		currentcolor=${color}

		i3-msg reload

		sleep 2

	fi

	sleep 2

done

# barcolor <colorclass> <border> <background> <text>

# class    <border> <backgr> <text> <indicator> <child_border>

# <separator>
