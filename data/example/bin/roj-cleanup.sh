#!/usr/bin/env bash

# Command for removing unused networks, volumes and images

docker network ls -q | xargs docker network rm

docker volume ls -q | xargs docker volume rm

# Filter broken on swarm, see https://github.com/docker/swarm/issues/1700 and https://github.com/docker/swarm/pull/2514
docker images -a | grep "none" | awk '{print $3}' | xargs docker rmi
