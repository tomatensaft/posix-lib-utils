#!/bin/sh
# SPDX-License-Identifier: MIT

# set -x

# check if script root path is set from main script
if [ ! -z ${SCRIPT_ROOT_PATH} ]; then
	printf "$0: script root path set - use ${SCRIPT_ROOT_PATH} for include\n"
else
	printf "$0: script rootpath ${SCRIPT_ROOT_PATH} not found - use local\n"
	SCRIPT_ROOT_PATH=./
fi

# include external libs from git module
if [ -f  ${SCRIPT_ROOT_PATH}/posix-lib-utils/standard_lib.sh ]; then
    printf "$0: include script from ${SCRIPT_ROOT_PATH}\n"
    . ${SCRIPT_ROOT_PATH}/posix-lib-utils/standard_lib.sh
else
    printf "$0: standardlib not found - exit\n"
    exit 1
fi