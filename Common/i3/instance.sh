#!/bin/bash

#set -x

if [[ ! $1 ]]; then

	exit 1

fi

for i in "$@"; do

	if [[ ${args} ]]; then

		args="${args} ${i}"

	else

		args="${i}"

	fi

done

if echo "$1" | grep -q -F ".sh"; then

	args="sh ${args}"

fi

if pgrep -a -x -f "${args}"; then

	exit 2

fi

eval "${args}"

exit $?
