#!/bin/bash

# Do not exit on error, we may not reach exec CMD (TODO)
set +e

cat <<'EOT'

 ######
 ##   ##            ##
 ##   ##  #####  ##   ##
 ######  ##   ## ##  ###
 ##      ##   ## ## # ##
 ##      ##   ## ###  ##
 ##       #####  ##   ##

EOT

# link SSH configuration
ln -s /roj/config/root/.ssh /root/.ssh

# Warn if the DOCKER_HOST socket does not exist
if ! [ -e /roj/config/env ]; then
    cat >&2 <<-EOT
WARNING: No env file for roj found.
EOT
fi

# Import env file
echo "Importing ENV configuration..."
export $(cat /roj/config/env | grep -v ^# | xargs)
export PATH=${ROJ_SCRIPTS_PATH}:$PATH

# Show versions
docker-machine --version
docker --version
docker-compose --version

# ensure var is not empty or whitespace
ROJ_MACHINE_DEFAULT=$(echo ${ROJ_MACHINE_DEFAULT})
if [ -z "${ROJ_MACHINE_DEFAULT}" ]; then
    echo "ROJ_MACHINE_DEFAULT is not set, use ROJ_SWARM_NAME, ROJ_SEPARATOR, ROJ_MASTER_ID"
    ROJ_MACHINE_DEFAULT="${ROJ_SWARM_NAME}${ROJ_SEPARATOR}${ROJ_MASTER_ID}"
fi

# Configure Docker endpoint
echo "Preparing Docker environment for '${ROJ_MACHINE_DEFAULT}'..."
eval $(docker-machine env --shell bash ${MACHINE_RC_OPTS} ${ROJ_MACHINE_DEFAULT})

# Show info
docker info

# Execute CMD
exec "$@"
