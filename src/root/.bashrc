ln -s /roj/config/root/.ssh /root/.ssh

# Import env file
echo "Importing ENV configuration..."
export $(cat /roj/config/env | grep -v ^# | xargs)

# TODO: move to `env`
export ROJ_MACHINE_OPTS="--swarm-discovery consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} --engine-opt=cluster-store=consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} --engine-opt=cluster-advertise=eth1:2376"


# Configuring prompt
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"
export PS1='${GREEN}${ROJ_SWARM_NAME}${RESET} $(pwd)> '

docker-machine --version
docker --version
docker-compose --version

echo "Preparing Docker environment for '${ROJ_SWARM_NAME}${ROJ_SEPARATOR}${ROJ_MASTER_ID}'..."
eval $(docker-machine env --shell bash ${MACHINE_RC_OPTS} ${ROJ_SWARM_NAME}${ROJ_SEPARATOR}${ROJ_MASTER_ID})
docker info
