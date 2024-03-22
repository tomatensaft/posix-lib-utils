#!/bin/sh
# SPDX-License-Identifier: MIT

set -u

#check git client - needed for different software
#$1 exit (EXT) or return (RET)
check_git() {

	#Preconfigure ExitState
	exit_state=${1:-RET}

    if pkg info git | grep git; then
        log -info "git Found"
    else
		log -info "install git"
        pkg install -y git 
    fi

}