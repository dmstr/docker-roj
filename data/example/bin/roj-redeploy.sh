#!/usr/bin/env bash

# Green-blue redeployment script for docker-compose
#
# Requirements: docker-compose.yml in ${STACK_DIR} (defaults to currenty working directory)
#
# Loop testing: (while true; roj-redeploy.sh; done;) >> /roj/_log/loop.log 2>&1

set -e

# Check directory
STACK_DIR=${STACK_DIR:-$(pwd)}
if [[ ! $(find ${STACK_DIR} -maxdepth 1 -name docker-compose.yml) ]]; then
    echo "Error: docker-compose.yml not found"
    exit 1
fi

cd ${STACK_DIR}

# Import or auto-detect and sanitize compose project name for usage directly with docker client
export $(cat .env | grep -v ^# | xargs)
COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME:-$(basename $(pwd))}
COMPOSE_PROJECT_NAME_SANITIZED=$(echo $COMPOSE_PROJECT_NAME | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')

export GREEN_STACK_NAME=${COMPOSE_PROJECT_NAME_SANITIZED}
export BLUE_STACK_NAME=${COMPOSE_PROJECT_NAME_SANITIZED}blue

_green="$(echo -e "\033[32m")"
_blue="$(echo -e "\033[34m")"
_warning="$(echo -e "\033[43m\033[30m")"
_default="$(echo -e "\033[39m\033[49m")"

# Start redeployment
echo ""
echo ""
echo -e "${_default}=> Redeploy\e[21m"

echo "Project name: ${COMPOSE_PROJECT_NAME_SANITIZED}"

if [[ ! ${STACK_UP_ONLY} ]]; then

    echo ""
    echo "Pulling stack images..."
    docker-compose pull

    if [[ ! $(docker-compose ps | grep "Exit") && $(docker-compose ps | grep "Up") ]]; then
        n=0
        until [ $n -ge 20 ]
        do
            n=$[$n+1]

            set +e
            export COMPOSE_PROJECT_NAME=${BLUE_STACK_NAME}

            echo ""
            echo "${_blue}-> Cleaning up stale 'blue' stacks..."
            docker-compose down -v --remove-orphans
            (docker network ls | grep ${BLUE_STACK_NAME}_default | awk '{print $1}' | xargs -r docker network rm)
            docker ps | grep "${BLUE_STACK_NAME} "

            echo ""
            echo -e "${_blue}-> Setting up temporary 'blue' stack..."
            export COMPOSE_PROJECT_NAME=${BLUE_STACK_NAME}
            (docker ps | grep ${BLUE_STACK_NAME}) || echo "Blue clean."
            (docker-compose up -d && docker-compose ps) && break

            echo -e "${_warning}--> Retry $n in 10 seconds${_default}"
            sleep 10
        done
    else
        echo -e "${_warning}[!] Exited containers in 'green' stack found, skipped cleanup & deployment of 'blue' stack${_default}"
    fi

fi

# TODO catch 20 retries

set -e

echo ""
echo -e "${_green}-> Redeploying main stack..."
export COMPOSE_PROJECT_NAME=${GREEN_STACK_NAME}

n=0
until [ $n -ge 20 ]
do
    n=$[$n+1]

    set +e
    echo -e "${_green}--> Cleanup stale networks (ignore active endpoints error)..."
    docker network ls | grep ${GREEN_STACK_NAME}_default | awk '{print $1}' | xargs -r docker network rm
    if [[ ! ${STACK_UP_ONLY} ]]; then
        echo -e "${_green}--> down"
        docker-compose down -v --remove-orphans
    fi

    echo -e "${_green}--> up"
    docker-compose up -d && break
    set -e

    echo -e "${_warning}--> Retry $n in 10 seconds${_default}"
    sleep 10
done

# TODO catch 20 retries

docker-compose ps

echo ""
echo "${_blue}-> Removing 'blue' stack..."
export COMPOSE_PROJECT_NAME=${BLUE_STACK_NAME}
docker-compose down -v --remove-orphans
docker network ls | grep ${BLUE_STACK_NAME}_default | awk '{print $1}' | xargs -r docker network rm

echo ""
echo -e "${_default}"
echo "Done."

sleep 3