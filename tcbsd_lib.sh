#!/bin/sh
# SPDX-License-Identifier: MIT

#set -x

# include external libs from git module
if [ -f  ./posix-lib-utils/standard_lib.sh ]; then
    . ./posix-lib-utils/standard_lib.sh
else
    printf "$0: standardlib not found - exit."
    exit 1
fi

# check if Jail exists
# $1 JailName
# $2 Exit (EXT) or Return (RET)
check_jail() {

	#Preconfigure ExitState
	exit_state=${2:-RET}

    if jls | grep $1; then
        log -info "jail ${1} found"
		cleanup_exit RET 0	#Allways returns 0 on success
    else
		log -info "jail ${1} not found"
		cleanup_exit $exit_state 1
        
    fi
}

# check nic
# $1 nic interface
# $2 Exit (EXT) or Return (RET)
check_nic_device() {

	#Preconfigure ExitState
	nic=${1:-invalid}
	exit_state=${2:-RET}

	if ifconfig | grep $nic; then
		log -info "nic ${nic} device found."
		cleanup_exit $exit_state 0
	else	
		log -info "no nic ${nic} device found."
        cleanup_exit $exit_state 1
	fi
}


# check VirtualBox device
# $1 Exit (EXT) or Return (RET)
check_vbox_device() {

	#Preconfigure ExitState
	exit_state=${1:-RET}

	if sysctl -a | grep VBOX; then
		log -info "vbox device found."
		cleanup_exit $exit_state 0
	else	
		log -info "no vbox device found."
        cleanup_exit $exit_state 1
	fi
}


# set Vbox defaults
# extend to CX and IPC devices
load_device_defaults() {

	if sysctl -a | grep VBOX; then
		log -info "vbox device found - set default values for virtualbox"

		log -info "set external interfaces to em0"
		net_external_if="em0"  #external for network/internet
		vpn_jail_external_if="em0" #External Jail interface for RDR

	else	
		log -info "no vbox device found - use parameterfile"
	fi
	
}


# check software package
# $1 command/program
# $2 Exit (EXT) or Return (RET)
check_software_pkg() {

	#Preconfigure ExitState
	exit_state=${2:-ERR}

	#Find Command
    if command -v $1 >/dev/null 2>&1 ; then
        log -info "[ $1 ] command found"
    else
        log -info "[ $1 ] command not found"

		#Find package
		if pkg info $1 | grep $1; then
			log -info "[ $1 ] package found, but command not working"
			cleanup_exit $exit_state
		else
			log -info "[ $1 ] package installed"
			pkg install -y $1 
		fi
    fi 
}


# switch Repot at TcBSD device
# $1 freebsd/bhf (freebsd / bhf)
# $2 Exit (EXT) or Return (RET)
switch_tcbsd_repo() {

	#Preconfigure ExitState
	exit_state=${2:-ERR}

	#tcbsd config file for official repo
	pkg_file="/usr/local/etc/pkg/repos/FreeBSD.conf"

	#check option
	if [ $1 == "bhf" ] ; then
		log -info "switch to beckoff repo"
		sed -i '' 's|yes|no|g' $pkg_file
		
		#update metadata
		pkg update

	elif [ $1 == "freebsd" ] ; then
		log -info "switch to official repo"
        sed -i '' 's|no|yes|g' $pkg_file

		#update metadata
		pkg update

	else
		log -info "repo option not found - use freebsd or bhf"
		cleanup_exit $exit_state
	fi

}

# check git client - needed for different software
# $1 exit (EXT) or return (RET)
check_git_bsd() {

	#Preconfigure ExitState
	exit_state=${1:-RET}

    if pkg info git | grep git; then
        log -info "git Found"
    else
		log -info "install git"
        pkg install -y git 
    fi

}