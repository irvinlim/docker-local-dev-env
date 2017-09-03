#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Stop existing container if it is running.
if [[ $(docker container ls | grep portainer) ]]
then

    echo "Portainer is already running! Restarting existing container..."
    docker restart portainer &>/dev/null

    # Connect to nginx-proxy network if needed. All containers to be proxied should be on this network.
    docker network connect nginx-proxy portainer &>/dev/null

else

    # Run the portainer image.
    PORTAINER_ID=$(
        docker run -d \
        --name portainer \
        --restart always \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        -v /usr/local/etc/portainer/data:/data \
        -e VIRTUAL_HOST=portainer.local \
        portainer/portainer
    )
    
    echo "Created container $PORTAINER_ID."

    # Connect the container to the nginx-proxy network to be accessible.
    docker network connect nginx-proxy portainer &> /dev/null
fi

echo -e "${GREEN}Success! Portainer is now running at http://portainer.local/.${NC}"
