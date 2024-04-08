#!/bin/sh
#SPDX-License-Identifier: MIT

#set -x

# set absolute path of root app for global use - relative path from this point
# ${PWD%/*} -> one folder up / ${PWD%/*/*} -> two folders up 
SCRIPT_ROOT_PATH="${PWD%/*}"

# load config file for default git parameters
if [ -f  ${SCRIPT_ROOT_PATH}/debug/shell_debug.conf ]; then
    printf "$0: include default git parameters from ${SCRIPT_ROOT_PATH}\n"
    . ${SCRIPT_ROOT_PATH}/debug/shell_debug.conf
else
    printf "$0: git lib default parameters not found - exit\n"
    exit 1
fi

# test include external libs from debian submodule
if [ -f  ${SCRIPT_ROOT_PATH}/main_lib.sh ]; then
    . ${SCRIPT_ROOT_PATH}/main_lib.sh
else
    printf "$0: main libs not found - exit.\n"
    exit 1
fi

#print header
print_header "debug posix lib"


log -info "test TLS"

#inlude automatically
#create_folder ${CERT_LOCATION}
#openssl_x509_rsa