#!/bin/bash

. mailcow.conf
./build-network.sh

NAME="memcached-mailcow"

echo "Stopping and removing containers with name tag ${NAME}..."
if [[ ! -z $(docker ps -af "name=${NAME}" -q) ]]; then
    docker stop $(docker ps -af "name=${NAME}" -q)
    docker rm $(docker ps -af "name=${NAME}" -q)
fi

if [[ ! -z "$(docker images -q rmilter)" ]]; then
    read -r -p "Found image locally. Rebuild anyway? [y/N] " response
    response=${response,,}
    if [[ $response =~ ^(yes|y)$ ]]; then
        docker rmi memcached
    fi
fi

docker run \
	--network=${DOCKER_NETWORK} \
	-h memcached \
	--network-alias memcached \
	--name=${NAME} \
	-d memcached