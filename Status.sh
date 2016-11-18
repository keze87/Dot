#!/bin/bash

cd ~/.Dot/ || exit 1

laptop=()
desktop=()

while read -r file; do

	filename=$(echo "${file}" | cut -d/ -f3-)

	aux=$(find Laptop/ -type f -name "${filename}")

	if [[ ${aux} ]]; then

		desktop+=( ${file} )

		laptop+=( ${aux} )

	fi

done < <( find Desktop/ -type f -print)

if [[ ${#desktop[@]} -eq ${#laptop[@]} ]]; then

	for (( i = 1 ; i <= ${#desktop[@]} ; i++ )); do

		vimdiff "${desktop[$i]}" "${laptop[$i]}"

	done

fi
