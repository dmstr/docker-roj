# Cheatsheet

List running docker images

    docker ps | awk '{print $4}' | sort | uniq