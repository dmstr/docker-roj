boilr template use stacks .

- Allocate Elastic IP
- Setup security group


    docker-machine create \
        -d amazonec2 \
        --engine-label discovery=1 \
        discovery

Setup discovery        
        
    cd discovery/consul
    eval $(docker-machine env discovery)
    docker-machine ssh discovery sudo sh -c 'mkdir -p /host-volume/consul/data && chmod -R 777 /host-volume/consul/data'
    docker-compose up -d        
    
:bulb: You can use a `.env` file for *Docker Compose* to point to the discovery VM by default `docker-machine env discovery > .env`

:warning: Setup ACLs or another access control for Consul.

Test consul UI in browser.

:warning: Double check cluster-advertise interface

Setup master

    docker-machine create \
        -d amazonec2 \
        --swarm-master \
        --swarm \
        --engine-label master=1 \
        --swarm-discovery consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} \
        --engine-opt=cluster-store=consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} \
        --engine-opt=cluster-advertise=eth0:2376 \
        ${ROJ_SWARM_NAME}-m1


Setup app (worker) node        
        
    docker-machine create \
        -d amazonec2 \
        --swarm \
        --engine-label app=1 \
        --swarm-discovery consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} \
        --engine-opt=cluster-store=consul://${ROJ_DISCOVERY_PUBLIC_IP}:8500/${ROJ_SWARM_NAME} \
        --engine-opt=cluster-advertise=eth0:2376 \
        ${ROJ_SWARM_NAME}-w10
