#!/bin/sh
# SPDX-License-Identifier: MIT

set -u

# log message
# $1 message text
log_message() {

   log=${1:-"no text"}
   printf "\n$(date +%Y-%m-%d-%H-%M-%S): ${log}\n"
   printf "########################################\n"

}
