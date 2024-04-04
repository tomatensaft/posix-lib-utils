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
* add as `git add submodule https://github.com/tomatensaft/posix-lib-uitls` in the git project

## usage 
include in the prefered lib in your shell script
```
# include external libs from git submodule
if [ -f  ./posix-lib-utils/standard_lib.sh ]; then
    . ./posix-lib-utils/docker_lib.sh
else
    printf "$0: external libs not found - exit."
    exit 1
fi
```

## libraries
* linux(debian) [lib](debian_lib.sh)
* freebsd (tcbsd) [lib](tcbsd_lib.sh)
* docker [lib](docker_lib.sh)
* git [lib](git_lib.sh)
* standard function [lib](standard_lib.sh)

## tests
* not testet completly
  
---
*[v0.1.0]*


