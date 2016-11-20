#!/usr/bin/env bash

# Command to recursively execute a command when a docker-compose.yml is found in a directory

echo $1

find $1 -type f -iname "docker-compose.yml" -print0 | while IFS= read -r -d $'\0' line; do
    echo ""
    #echo "$line"
    #ls -l "$line"
    pushd $(dirname $line)
    echo "======================================================="
    $2
    popd
done
