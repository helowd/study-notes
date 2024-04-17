#!/bin/bash

SCAN_PATH="/usr/local"


main() {
	if [[ ! -z $1 ]];then
		SCAN_PATH=$1
	fi
	declare -a directories
	directories=($(ls ${SCAN_PATH}))

	for dir in "${directories[@]}"; do
		bin_path="${SCAN_PATH}/${dir}/bin"
		if [[ -d ${bin_path} ]];then
			export PATH="${PATH}:${bin_path}"
		fi
	done
	
	if (( $? == 0 ));then
		echo "Init PATH successfully."
		echo "PATH=${PATH}"
	fi
}


main "$@"