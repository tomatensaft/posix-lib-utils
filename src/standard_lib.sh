#!/bin/sh
# SPDX-License-Identifier: MIT

# set -x

# load config file for default parameters
if [ -f  ${SCRIPT_ROOT_PATH}/conf/standard_lib.conf ]; then
    printf "$0: include default standard parameters from ${SCRIPT_ROOT_PATH}\n"
    . ${SCRIPT_ROOT_PATH}/conf/standard_lib.conf
else
    printf "$0: standardlib default standard parameters not found - exit\n"
    exit 1
fi

# header functions
# $1 header
print_header()
{

	printf "\n################################################\n"
	printf "$LIB_HEADER -- $1"
	printf "\n################################################\n\n"
}

# print header
print_header 'load shared lib'

# find & replace
# $1 file
# $2 parameter
# $3 value
add_or_replace_in() {
	
	if grep "^$2" "$1" > /dev/null; then
		sed -i "" "s|^$2.*|$2$3|g" "$1"
	else
		echo "$2$3" >> "$1"
	fi
}


# log message
# $1 message text
log_message() {

    log=${1:-"no text"}
    printf "\n$(date +%Y-%m-%d-%H-%M-%S): ${log}\n"
    printf "########################################\n"

}


# log Message
# $1 option
log() {

	# check Inputargs
		case $1 in
				-info)
					printf "\nINFO [$(date +'%Y-%m-%dT%H:%M:%S')]: $2 \n"
					;;
				-header)
					printf "$2 \n"
					;;

				-error)
					printf "\nERROR [$(date +'%Y-%m-%dT%H:%M:%S')]: $2 \n"
					;;	

				-file)
					printf "\n[$(date +'%Y-%m-%dT%H:%M:%S')]: $2 \n"
					;;	

				*)
					printf "$0 Usage: -"
					printf "[info,header,error,file]\n\n"
					exit 1
					;;
		esac
}


# usage
usage() {
	printf "\n++++++++++++ Usage / Help ++++++++++++++++\n\n"
	for help in "$@"
		do
			printf "$help\n"
		done
	printf "++++++++++++++++++++++++++++++++++++++++++\n"
    cleanup_exit ERR
}


# cleanup & Exit
# $1 Option
# $2 Exit (EXT) or Return (RET)
cleanup_exit() {

	# preconfigure exitstate
	exit_state=${2:-0}

    case $1 in
            OK)
                log -info "cleanup & exit state -> EXIT - OK\n"
                exit 0
                ;;

            ERR)
                log -info "cleanup & exit state -> EXIT - ERROR\n"
                exit 1
                ;;
			EXT)
                log -info "cleanup & exit state -> EXIT ${exit_state}\n"
                exit $exit_state
                ;;		
			RET)
                log -info "cleanup & exit state -> RETURN ${exit_state}\n"
                return $exit_state
                ;;	
            *)
                log -info "cleanup & exit state -> EXIT - DEFAULT\n"
                exit 1      
                ;;
    esac
}

# check Root
# $1 Exit (EXT) or Return (RET)
check_root() {
	
	#preconfigure exitstate
	exit_state=${1:-ERR}

    if [ $(id -u) -ne 0 ]; then
        log -info "usage: run '$0' as root."
        cleanup_exit $exit_state
    fi
}

# check Arguements ($# Arguments / Count of Args)
# $1 requestet Args
# $2 actual args
# $3 exit (EXT) or return (RET)
check_args() {

	#preconfigure exitstate
	exit_state=${3:-ERR}

	if [ "$1" -lt "$2" ]; then
		log -error "number of parameters wrong. see --help."
        cleanup_exit $exit_state
	fi
}

# check beckhoff device
# $1 Exit (EXT) or Return (RET)
check_bhf_device() {

	#preconfigure exitstate
	exit_state=${1:-RET}

	if uname -a | grep BHF; then
		log -info "beckhoff device found."
		cleanup_exit $exit_state 0
	else	
		log -info "no beckhoff device found."
        cleanup_exit $exit_state 1
	fi
}


# load config file
# $1 configuration file
# $2 Exit (EXT) or Return (RET)
load_config() {

	#preconfigure exitState
	exit_state=${2:-ERR}

    #load parameter file
    #define parameters in configfile
    if [ -f $1 ]; then
        log -info "$0: $1 parameter file found."
        . $1
    else
        log -info "$0: $1 no parameter file found."
        cleanup_exit $exit_state
    fi

}

# create cert folders
# $1 certifcation folder
create_folder() {

    log -info "$0: create folder $1"
    mkdir -p $1

}



#yes/no to continue
continue_yes_no() {

    while true; do
        read -p "continue setup [y]es or [n]o ?" result
        case ${result} in
            [Yy]* ) make install; break;;
            [Nn]* ) exit;;
            * ) printf "only [y]es or [n]o.\n";;
        esac
    done

}


#test configuration
test_configuration() {

    log -info "test configuration"
}
