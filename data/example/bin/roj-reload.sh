#!/usr/bin/env bash

# Stack reload script

[ -z "$STACK_DIR" ] && echo "Error: STACK_DIR variable is not set" && exit 1

cd ${STACK_DIR}

docker-compose down -v --remove-orphans
docker-compose up -d
docker-compose ps

