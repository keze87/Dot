#!/bin/bash
#vim set lang spanglish

if [[ $1 ]]; then

	host=$1;

else

	host='Desktop';

fi

config=~/.config/i3/config
currentcolor='#nerfed'

known=( 'spotify' 'geany' 'terminator' )

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

		head -n -1 .Dot/${host}/i3/config > .barconfig

		mv .barconfig .config/i3/config

		case ${color} in

			Negro)

				echo '
					colors {
						separator #4080FB
						background #000000
						statusline #ffffff
						focused_workspace #4080FB #4080FB #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #000000 #000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #4080FB #4080FB #ffffff #4080FB
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#4080FB'	>> "${config}"

			;;

			spotify)

				echo '
					colors {
						separator #1DB954
						background #282828
						statusline #ffffff
						focused_workspace #1DB954 #1DB954 #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #282828 #282828 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #1DB954 #1DB954 #ffffff #1DB954
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #282828 #282828 #ffffff #454749
				#1ED660'	>> "${config}"

			;;

			geany)

				echo '
					colors {
						separator #8AE234
						background #454749
						statusline #ffffff
						focused_workspace #8AE234 #8AE234 #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #454749 #454749 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #8AE234 #8AE234 #ffffff #8AE234
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#8AE234'	>> "${config}"

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
						separator #662C91
						background #00000000
						statusline #ffffff
						focused_workspace #662C91 #662C91 #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #00000000 #00000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #4080FB #4080FB #ffffff #4080FB
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#662C91'	>> "${config}"

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
				client.focused #4080FB #4080FB #ffffff #4080FB
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#ED1A5F'	>> "${config}"

			;;

			*) # Transparente

				echo '
					colors {
						separator #4080FB
						background #00000000
						statusline #ffffff
						focused_workspace #4080FB #4080FB #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #00000000 #00000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #4080FB #4080FB #ffffff #4080FB
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#4080FB'	>> "${config}"

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
