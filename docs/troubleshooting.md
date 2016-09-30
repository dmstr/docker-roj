# Troubleshooting

### `No such network:`

  ERROR: for redis  No such network: wwwcenturionde_default
  ERROR: Encountered errors while bringing up the project.

- check your networks with `docker network ls`
- remove duplicate ones by ID
- `docker-compose down`
- `docker-compose up`


SSH connection (should work without `docker-machine` provisioning

     ssh -i ./config/id_rsa-staging-1.oneba.se \
         -o PasswordAuthentication=no \
         -o StrictHostKeyChecking=no \
         -o UserKnownHostsFile=/dev/null \
         -o IdentitiesOnly=yes \
         vagrant@144.76.161.122

Swarm master provisioning

    docker-machine ssh sepp-m1

    $ sudo -s

    $ docker rm -fv swarm-agent-master

    $ docker run \
        -d \
        -v /etc/docker:/etc/docker \
        -p 3376:3376 \
        -e DOCKER_API_VERSION=1.22 \
        --name swarm-agent-master \
        swarm:1.1.3 --debug manage \
            --tlsverify --tlscacert=/etc/docker/ca.pem \
            --tlscert=/etc/docker/server.pem --tlskey=/etc/docker/server-key.pem -H tcp://0.0.0.0:3376 --strategy spread \
            --heartbeat=11s \
            --advertise 52.59.250.208:3376 \
            consul://172.31.11.162:8500/sepp
    
### Only set `VIRUAL_HOST` on webserver containers

Otherwise nginx config check, review with `nginx -T`, may fail.

    
### docker daemon restart

:warning: It's very likely this action causes downtime of services

    docker-machine ls -q | xargs -I {} docker-machine ssh {} sudo /etc/init.d/docker restart
    
    
### Unable to find a node that satisfies the following conditions
        
    ERROR: for appphp  Unable to find a node that satisfies the following conditions 
    [--link=wwwshopeurcom_redis_1:REDIS --link=wwwshopeurcom_redis_1:redis_1 --link=wwwshopeurcom_redis_1:wwwshopeurcom_redis_1]
    [image==registry-v2.hrzg.de/shopeur/www-shopeur-com-php/master-appphp:latest (soft=false)]
    Traceback (most recent call last):
      File "<string>", line 3, in <module>
      File "compose/cli/main.py", line 63, in main
    AttributeError: 'ProjectError' object has no attribute 'msg'
    docker-compose returned -1

"fix"

    docker-compose pull
    
    
### Check `VIRTUAL_HOST`
    
    make rcompose DIR=auto/ CMD=config | grep VIRTUAL
    
### Get files from a running container
    
    docker-compose exec php yii db/x-dump-data
    docker cp $(docker-compose ps -q php):/app/runtime/mysql/ ./_backup
    
    
### Show disk usage

    docker-machine ls -q | xargs -I{} docker-machine ssh {} sudo df -h
    

    docker-machine ssh sepp-m7 sudo docker restart swarm-agent-master
