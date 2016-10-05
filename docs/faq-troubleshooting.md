# FAQ

## Commands

### nginx config check

:information_sign: Only set `VIRUAL_HOST` on webserver containers

Run `nginx -T`, may fail.

### Check `VIRTUAL_HOST`
    
    make rcompose DIR=auto/ CMD=config | grep VIRTUAL

### Get files from a running container
    
    docker-compose exec php yii db/x-dump-data
    docker cp $(docker-compose ps -q php):/app/runtime/mysql/ ./_backup
    
    
### Show disk usage

    docker-machine ls -q | xargs -I{} docker-machine ssh {} sudo df -h
    

    docker-machine ssh sepp-m7 sudo docker restart swarm-agent-master


### Restart swarm master container

:warning: Do **NOT** restart directly via `docker`

    docker-machine ssh PAUL-m2 sudo docker restart swarm-agent-master

### docker daemon restart

:warning: It's very likely this action causes downtime of services

    docker-machine ls -q | xargs -I {} docker-machine ssh {} sudo /etc/init.d/docker restart

---

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
         vagrant@10.0.0.1

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
            --advertise 10.2.0.8:3376 \
            consul://10.5.1.100:8500/sepp
    
    
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
    
    
    



###  High CPU load, `kswapd0`

#### add cache clear command to `crontab`

Option A)

    export MACHINE=swarm-x0

    docker-machine scp vm_drop_caches ${MACHINE}:vm_drop_caches
    docker-machine ssh ${MACHINE} sudo mv vm_drop_caches /etc/cron.hourly/vm_drop_caches
    docker-machine ssh ${MACHINE} sudo chmod ugo+x /etc/cron.hourly/vm_drop_caches
    docker-machine ssh ${MACHINE} sudo /etc/cron.hourly/vm_drop_caches

Option B)

    docker-machine ssh MACHINE-id0 \
        sudo bash -c "printf '#\!/bin/sh -eu\n\necho 1 | tee /proc/sys/vm/drop_caches' > /etc/cron.hourly/vm_drop_caches && chmod ugo+x /etc/cron.hourly/vm_drop_caches"

    $ sudo bash -c "printf '#\!/bin/sh -eu\n\necho 1 | tee /proc/sys/vm/drop_caches' > /etc/cron.hourly/vm_drop_caches && chmod ugo+x /etc/cron.hourly/vm_drop_caches"
    $ chmod ugo+x /etc/cron.hourly/vm_drop_caches

Apply manually
       
   $ echo 1 | sudo tee /proc/sys/vm/drop_caches

#### drop_cache doesn't help?

other "solution" from https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1518457/comments/108

```
export MACHINE=swarm-x0
docker-machine ssh ${MACHINE} sudo touch /etc/udev/rules.d/40-vm-hotadd.rules
```

Now you'll have to restart VM to 'activate' :-(


### Pull images

Error

    docker-compose-redeploy 
    No stopped containers
    Creating myapp_redis_1
    Creating myapp_appphp_1
    ERROR: Error: image herzog/bernd/epis-appphp:latest not found
    Done.

Solution
    
    docker-compose pull


### Example swarm master command

Remove exisiting master before creating a new one

    docker rm -fv swarm-agent-master

Mount the certificates inside the container and start swarm
    
    docker run -p 3376:3376 -v /etc/docker:/etc/docker/ --name swarm-agent-master -d swarm:1.1.0 \
        manage --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server.pem --tlskey=/etc/docker/server-key.pem \
        -H tcp://0.0.0.0:3376 --strategy spread --heartbeat=11s consul://10.5.1.100:8500/sepp

### High CPU load, `kswapd0`

`cron.hourly`

    #!/bin/sh -eu

    echo 1 | sudo tee /proc/sys/vm/drop_caches

### AWS was not able to validate the provided access credentials 

    Error checking TLS connection: AuthFailure: AWS was not able to validate the provided access credentials
            status code: 401, request id: 
    docker info
    Cannot connect to the Docker daemon. Is the docker daemon running on this host?

"fix time" in VM (`docker-machine`)
