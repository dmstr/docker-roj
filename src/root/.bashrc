# Configuring prompt
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"
export PS1='${GREEN}${ROJ_SWARM_NAME}${RESET} $(pwd)> '
