#!/bin/sh
# SPDX-License-Identifier: MIT

# set -x

# include external libs from git module
if [ -f  ./posix-lib-utils/standard_lib.sh ]; then
    . ./posix-lib-utils/standard_lib.sh
else
    printf "$0: standardlib not found - exit."
    exit 1
fi