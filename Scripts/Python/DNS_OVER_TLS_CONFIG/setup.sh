#!/usr/bin/env bash
set -e

# Check if the container is running already or in exited state
if [ ! "$(docker ps -q -f name=dns_over_tls)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=dns_over_tls)" ]; then
        # Remove it if its present
        docker rm dns_over_tls
    fi
fi

# Build it
docker build -t dns_over_tls .

# Start the container in detached mode
docker run -d --name dns_over_tls dns_over_tls
