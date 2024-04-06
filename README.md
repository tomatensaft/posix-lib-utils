# posix-lib-utils :books:
posix lib for tcbsd and linux

## contents
- [posix-lib-utils :books:](#posix-lib-utils-books)
  - [contents](#contents)
  - [installation](#installation)
  - [usage](#usage)
  - [libraries](#libraries)
  - [tests](#tests)

## installation
* add `git add submodule https://github.com/tomatensaft/posix-lib-uitls` in the git project
* for using the latest version include the `git_lib.sh` and update the submodulde `git_submodule_update`

## usage
optional copy `_lib.conf` files for parameters and adjust
when no file is set as parameter the standard file in the lib is used
include in the prefered lib in your shell script

set root path from main script
```
# ${PWD%/*} -> one folder up / ${PWD%/*/*} -> two folders up 
SCRIPT_ROOT_PATH="${PWD%/*}"
```

include lib in main script
```
# test include external libs from debian submodule
if [ -f  ${SCRIPT_ROOT_PATH}/debian_lib.sh ]; then
    . ${SCRIPT_ROOT_PATH}/debian_lib.sh
else
    printf "$0: debian external libs not found - exit.\n"
    exit 1
fi
```

## libraries
* linux(debian) [lib](debian_lib.sh)
* freebsd (tcbsd) [lib](tcbsd_lib.sh)
* docker [lib](docker_lib.sh)
* git [lib](git_lib.sh)
* standard functions [lib](standard_lib.sh)
* linux(debian) [debian_lib](debian_lib.sh)
* linux(alpine) [alpine_lib](alpine_lib.sh)
* twincat-bsd (tcbsd) [bsd_lib](tcbsd_lib.sh)
* docker [docker_lib](docker_lib.sh)
* git [git_lib](git_lib.sh)
* standard function [standard](standard_lib.sh)
* tls library [tls_lib](tls_lib.sh)

## tests
* not testet completly
  
---
*[v0.1.0]*


