#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

## Helper script for jwilder/nginx-proxy Docker reverse proxy.
## All virtual hosts have to first be defined in /etc/hosts.
## Sometimes if you get 503 errors and you need to restart nginx-proxy before restarting each container again.

# Stop the container if already running.
if [[ $(docker container ls | grep nginx-proxy) ]]
then 
    docker kill nginx-proxy &> /dev/null
    docker rm nginx-proxy &> /dev/null
fi

# Start the image and bind the container to port 80.
CONTAINER_ID=$(
    docker run -d \
        --name nginx-proxy \
        -p 80:80 \
        --restart always \
        -v /var/run/docker.sock:/tmp/docker.sock:ro \
        -v /usr/local/etc/nginx-proxy/dhparam:/etc/nginx/dhparam:ro \
        -v /usr/local/etc/nginx-proxy/certs:/etc/nginx/certs:ro  \
        -v /usr/local/etc/nginx-proxy/conf.d/custom.conf:/etc/nginx/conf.d/custom.conf:ro  \
        jwilder/nginx-proxy
)

echo "Created container $CONTAINER_ID."

# Check if the network already exists.
if [[ ! $(docker network ls | grep nginx-proxy) ]]
then
    docker network create nginx-proxy
fi

# Connect to nginx-proxy network. All containers to be proxied should be on this network.
docker network connect nginx-proxy nginx-proxy

echo -e "${GREEN}Success! nginx-proxy is now running.${NC}"
