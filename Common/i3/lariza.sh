#!/bin/bash

export LARIZA_HOME_URI="https://duckduckgo.com/?kae=t&kl=ar-es&kad=es_AR&kp=-2&k1=-1&kk=-1&kaj=m&kam=google-maps&kak=-1&kao=-1&kt=Cantarell&km=m&ko=1&ka=Cantarell"
export LARIZA_USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36"
#export LARIZA_USER_AGENT="Mozilla/5.0 (Linux; Android 7.1.2; Nexus 4 Build/N2G47J) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.132 Mobile Safari/537.36"
export LARIZA_ACCEPTED_LANGUAGE="es_AR"
export LARIZA_DOWNLOAD_DIR="${HOME}/"
export LARIZA_ENABLE_EXPERIMENTAL_WEBGL=1
#export GTK_THEME=Vertex-Maia

lariza -T &

disown
