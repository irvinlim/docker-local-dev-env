#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

## phpMyAdmin global instance.

# Stop the container if already running.
if [[ $(docker container ls | grep phpmyadmin) ]]
then 
    echo "The phpmyadmin container is already running! Stopping existing instance..."
    docker kill phpmyadmin &> /dev/null
fi

# Remove the container if already running.
if [[ $(docker container ls -a | grep phpmyadmin) ]]
then
    echo "The phpmyadmin container already exists! Removing existing instance..."
    docker rm phpmyadmin &> /dev/null
fi

# Update the Docker image.
docker pull phpmyadmin/phpmyadmin

# Start the image and bind the container to port 80.
CONTAINER_ID=$(
    docker run -d \
        --name phpmyadmin \
        --restart always \
        -e VIRTUAL_HOST=pma.local \
        -e PMA_ARBITRARY=1 \
        -e PMA_ABSOLUTE_URI=http://pma.local \
        phpmyadmin/phpmyadmin
)

echo "Created container $CONTAINER_ID."

# Connect to nginx-proxy network.
docker network connect nginx-proxy phpmyadmin

# Create phpmyadmin network.
docker network create phpmyadmin &> /dev/null
docker network connect phpmyadmin phpmyadmin

echo -e "${GREEN}Success! phpMyAdmin is now running at http://pma.local/.${NC}"
