# Building a swarm

## Requirements

- 3 machines accessible via SSH key

## Machine provisioning

Start by entering the roj management container

```
docker-compose run --rm roj
```

### Discovery

```
docker-machine create -d generic --generic-ip-address ${ROJ_DISCOVERY_PUBLIC_IP} discovery
```

```
cd discovery/consul
eval $(docker-machine env discovery)
docker-machine ssh discovery sudo mkdir -p /host-volume/consul/data
docker-machine ssh discovery sudo chmod -R 777 /host-volume/consul/data
```

TODO: Update consul version, swarm image, describe config/env, docker install URL
roj bind public private
ROJ_MASTER_PUBLIC_IP

```
docker-compose up -d
```

Open consul web UI http://10.1.1.1:8500


### Swarm master

:warning: Double-check your public IP with `ifconfig`, in the following commands the public IP is assigned to `eth1`

```
GENERIC_IP_ADDRESS=10.1.13.1 \
docker-machine create -d generic \
    --swarm-master \
    --swarm \
    --engine-label master=1 \
    --swarm-discovery consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} \
    --engine-opt=cluster-store=consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} \
    --engine-opt=cluster-advertise=eth1:2376 \
    ${ROJ_SWARM_NAME}-m1
```

:warning: After creating the swarm master you should either exit roj management container or 

```
eval $(docker-machine env --swarm ${ROJ_SWARM_NAME}-m1)
```

### App/worker nodes

```
GENERIC_IP_ADDRESS=10.1.13.22 \
docker-machine create -d generic \
    --swarm \
    --engine-label app=1 \
    --swarm-discovery consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} \
    --engine-opt=cluster-store=consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} \
    --engine-opt=cluster-advertise=eth1:2376 \
    ${ROJ_SWARM_NAME}-w22
```

You are now ready to deploy stacks with `docker-compose`.
