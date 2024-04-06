#!/bin/sh
# SPDX-License-Identifier: MIT

# set -x

# load config file for default docker parameters
if [ -f  ${SCRIPT_ROOT_PATH}/docker_lib.conf ]; then
    printf "$0: include default docker parameters from ${SCRIPT_ROOT_PATH}\n"
    . ${SCRIPT_ROOT_PATH}/docker_lib.conf
else
    printf "$0: docker lib default parameters not found - exit\n"
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


# docker check states
docker_check_state() {

    # active containers
    log -info "list active container"
    docker ps -a

    # list images
    log -info "list active images"
    docker images

    # list active networks
    log -info "list active networks"
    docker network ls

    # list active volumes
    log -info "list active volumes"
    docker volume ls
}


# docker compose reset
docker_compose_reset() {

    log -info "docker compose reset"
    docker compose restart
}

# docker compose stop
docker_compose_stop() {

    log -info "docker compose stop"
    docker compose stop
}


# docker compose start
docker_compose_start() {

    log -info "docker compose start"
    docker compose start
}


# setup docker
docker_setup_system() {

    # add gpg key
    log -info "add docker official gpg key"
    continue_yes_no
    apt-get update
    apt-get install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # add repo to sources
    log -info "add repo to sources"
    continue_yes_no
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    # install software
    log -info "install docker software"
    continue_yes_no
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    #test docker
    log -info "test docker system with hello world"
    continue_yes_no
    docker run hello-world

}


# delete docker data
docker_delete_data() {

    log -info "try shutdown all compose instances"
    docker compose down

    log -info "try shutdown the rest of the containers"
    docker stop $(docker ps -a -q) 

    log -info "reset docker instances"
    docker rm -f $(docker ps -a -q)
    docker rmi $(docker images -a -q)
    docker network rm $(docker network ls -q)
    docker volume rm $(docker volume ls -q)

    log -info "running instances"
    docker ps -a

    log -info "available offline images"
    docker images

}

# delete local data
# $1 path for docker volume
docker_delete_local_data() {

    log -info "delete prductive data/volume"

    # check volume parameter
    if [ ! -z $1 ]; then
        log -info "volume parameter $1 not found"
        exit 1
    else
        log -info "volume parameter found $1"
    fi

    # remove volume data
    if [ -d $1 ] && \
        [ ! $1 = "/" ] && \
        [ ! -z $1 ]; then
            log -info "delete filed in $1"
            rm -r $1
    fi
}