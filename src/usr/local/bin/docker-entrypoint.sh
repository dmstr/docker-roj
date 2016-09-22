#!/bin/bash

cat <<'EOT'

 ######
 ##   ##            ##
 ##   ##  #####  ##   ##
 ######  ##   ## ##  ###
 ##      ##   ## ## # ##
 ##      ##   ## ###  ##
 ##       #####  ##   ##

EOT

# run .bashrc
. ~/.bashrc

# Warn if the DOCKER_HOST socket does not exist
if ! [ -e /roj/env ]; then
    cat >&2 <<-EOT
WARNING: No env file for roj found.
EOT
fi


exec "$@"
