#!/bin/sh
# SPDX-License-Identifier: MIT

# set -x

# load config file for default debian parameters
if [ -f  ${SCRIPT_ROOT_PATH}/debian_lib.conf ]; then
    printf "$0: include default debian parameters from ${SCRIPT_ROOT_PATH}\n"
    . ${SCRIPT_ROOT_PATH}/debian_lib.conf
else
    printf "$0: debian lib default parameters not found - exit\n"
    exit 1
fi

# check if script root path is set from main script
if [ ! -z ${SCRIPT_ROOT_PATH} ]; then
	printf "$0: script root path set - use ${SCRIPT_ROOT_PATH} for include\n"
else
	printf "$0: script rootpath ${SCRIPT_ROOT_PATH} not found - use local\n"
	exit 1
fi

# include external libs from git module
if [ -f  ${SCRIPT_ROOT_PATH}/standard_lib.sh ]; then
    printf "$0: include script from ${SCRIPT_ROOT_PATH}\n"
    . ${SCRIPT_ROOT_PATH}/standard_lib.sh
else
    printf "$0: standardlib not found - exit\n"
    exit 1
fi