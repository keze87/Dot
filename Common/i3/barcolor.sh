#!/bin/bash
#vim set lang spanglish

if [[ -f ~/.dotlaptop ]]; then

	host='Laptop';

else

	host='Desktop';

fi

config=~/.config/i3/config
currentcolor='#nerfed'

known=( 'spotify' 'geany' 'terminator' 'konsole' 'kitty' 'chromium' 'okular' 'Navigator' 'lximageqt' 'libreoffice' 'Falkon' 'atom' 'pcmanfm' )

### tamaño pantalla
xChico=1200
yChico=700

xGrande=1880
yGrande=1040

x=${xChico}
y=${yChico}

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

				color='Negro'

			fi

		fi

		if [[ ! ${color} ]]; then

			color='Negro'

		fi

	else

		if [[ ${#ids[@]} -eq 0 ]]; then

			color="Escritorio${host}"

		else

			color='Transparente'

		fi

	fi

	case ${color} in

		geany|chromium|okular|lximageqt|libreoffice|Falkon|pcmanfm)

			color='appTheme'

		;;

	esac

	if [[ ${cantMonitor} == 2 ]]; then

		color='Negro'

	fi

	if [[ ${color} != "${currentcolor}" ]]; then

		rm .barconfig
		rm "${config}"

		cat .Dot/${host}/i3/config .Dot/Common/i3/config > .barconfig

		head -n -1 .barconfig > "${config}"

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

			atom)

				echo '
					colors {
						separator #B07745
						background #393344
						statusline #F1EBFF
						focused_workspace #302A39 #302A39 #F1EBFF
						active_workspace #302A39 #302A39 #F1EBFF
						inactive_workspace #393344 #393344 #F1EBFF
						urgent_workspace #900000 #900000 #F1EBFF
					}
				}
				client.focused #302A39 #302A39 #F1EBFF #302A39
				client.focused_inactive #302A39 #302A39 #F1EBFF #302A39
				client.unfocused #393344 #393344 #F1EBFF #393344
				#B07745'	>> "${config}"

			;;

			Navigator)

				echo '
					colors {
						separator #0A84FF
						background #0C0C0D
						statusline #ffffff
						focused_workspace #0A84FF #0A84FF #ffffff
						active_workspace #2C3133 #2C3133 #ffffff
						inactive_workspace #0C0C0D #0C0C0D #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #0A84FF #0A84FF #ffffff #0A84FF
				client.focused_inactive #353638 #353638 #ffffff #0C0C0D
				client.unfocused #0C0C0D #0C0C0D #ffffff #0C0C0D
				#0A84FF'	>> "${config}"

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

			 appTheme)

				echo '
					colors {
						separator #3DAEE9
						background #31363B
						statusline #ffffff
						focused_workspace #31363B #31363B #3DAEE9
						active_workspace #31363B #31363B #3DAEE9
						inactive_workspace #31363B #31363B #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #3DAEE9 #3DAEE9 #ffffff #3DAEE9
				client.focused_inactive #353638 #353638 #ffffff #31363B
				client.unfocused #31363B #31363B #ffffff #31363B
				#3DAEE9'	>> "${config}"

			;;

			terminator | konsole | kitty)

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
						separator #5DC632
						background #00000000
						statusline #ffffff
						focused_workspace #5DC632 #5DC632 #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #00000000 #00000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #16A085 #16A085 #ffffff #16A085
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#5DC632'	>> "${config}"

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
						separator #3DAEE9
						background #00000000
						statusline #ffffff
						focused_workspace #3DAEE9 #3DAEE9 #ffffff
						active_workspace #454749 #454749 #ffffff
						inactive_workspace #00000000 #00000000 #ffffff
						urgent_workspace #900000 #900000 #ffffff
					}
				}
				client.focused #3DAEE9 #3DAEE9 #ffffff #3DAEE9
				client.focused_inactive #353638 #353638 #ffffff #454749
				client.unfocused #454749 #454749 #ffffff #454749
				#3DAEE9'	>> "${config}"

			;;

		esac

		currentcolor=${color}

		i3-msg reload

		if [[ ${cantMonitor} == 2 ]]; then

			exit

		fi

	fi

	sleep 2

done

# barcolor <colorclass> <border> <background> <text>

# class    <border> <backgr> <text> <indicator> <child_border>

# <separator>
