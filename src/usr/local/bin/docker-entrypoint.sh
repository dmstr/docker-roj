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

# Show versions
docker-machine --version
docker --version
docker-compose --version

# Configure Docker endpoint
echo "Preparing Docker environment for '${ROJ_SWARM_NAME}${ROJ_SEPARATOR}${ROJ_MASTER_ID}'..."
eval $(docker-machine env --shell bash ${MACHINE_RC_OPTS} ${ROJ_SWARM_NAME}${ROJ_SEPARATOR}${ROJ_MASTER_ID})

# Show info
docker info

# Execute CMD
exec "$@"
