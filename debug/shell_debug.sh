#!/bin/sh
#SPDX-License-Identifier: MIT

#set -x

# set absolute path of root app for global use - relative path from this point
# ${PWD%/*} -> one folder up / ${PWD%/*/*} -> two folders up 
SCRIPT_ROOT_PATH="${PWD%/*}"

# test include external libs from debian submodule
if [ -f  ${SCRIPT_ROOT_PATH}/debian_lib.sh ]; then
    . ${SCRIPT_ROOT_PATH}/debian_lib.sh
else
    printf "$0: debian external libs not found - exit.\n"
    exit 1
fi

# test include external libs from alpine submodule
if [ -f  ${SCRIPT_ROOT_PATH}/alpine_lib.sh ]; then
    . ${SCRIPT_ROOT_PATH}/alpine_lib.sh
else
    printf "$0: alpine external libs not found - exit.\n"
    exit 1
fi

# test include external libs from docker submodule
if [ -f  ${SCRIPT_ROOT_PATH}/docker_lib.sh ]; then
    . ${SCRIPT_ROOT_PATH}/docker_lib.sh
else
    printf "$0: docker external libs not found - exit.\n"
    exit 1
fi

# test include external libs from git submodule
if [ -f  ${SCRIPT_ROOT_PATH}/git_lib.sh ]; then
    . ${SCRIPT_ROOT_PATH}/git_lib.sh
else
    printf "$0: git external libs not found - exit.\n"
    exit 1
fi

# test include external libs from tls submodule
if [ -f  ${SCRIPT_ROOT_PATH}/tls_lib.sh ]; then
    . ${SCRIPT_ROOT_PATH}/tls_lib.sh
else
    printf "$0: tls external libs not found - exit.\n"
    exit 1
fi

# test include external libs from tcbsd submodule
if [ -f  ${SCRIPT_ROOT_PATH}/tcbsd_lib.sh ]; then
    . ${SCRIPT_ROOT_PATH}/tcbsd_lib.sh
else
    printf "$0: tcbsd external libs not found - exit.\n"
    exit 1
fi

#print header
print_header "debug posix lib"


log -info "test TLS"

#inlude automatically
create_folder ${CERT_LOCATION}
openssl_x509_rsa