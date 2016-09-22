#!/usr/bin/env bash

echo "Version: $ROJ_VERSION"

cat <<'EOT'

Commands:
  docker-machine
  docker
  docker-compose

Examples:
  docker-machine -h         Show machine help
  docker-machine ls         Show configured machines
  docker-machine ssh ...    SSH into machine
  docker -h                 Show docker client help
  docker ps                 Show all running containers
  docker ps -a              Show all containers
  docker -h                 Show docker-compose help
  docker-compose ps         Show running container from current stack directory

EOT
