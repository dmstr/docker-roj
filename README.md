# roj

### Machine provisioning

```
docker-machine create -d generic --generic-ip-address 10.1.1.1 discovery
```

```
cd discovery/consul
eval $(docker-machine env discovery)
docker-machine ssh discovery sudo mkdir -p /host-volume/consul/data
docker-machine ssh discovery sudo chmod -R 777 /host-volume/consul/data
docker-compose up -d
```

http://10.1.1.1:8500

:warning: Double-check your public IP with `ifconfig`, in the following commands the public IP is assigned to `eth1`

```
docker-machine create -d generic --generic-ip-address 10.10.10.1 \
    --swarm-master \
    --swarm \
    --engine-label master=1 \
    ${ROJ_MACHINE_OPTS} \
    ${ROJ_SWARM_NAME}-m1 & \    
docker-machine create -d generic --generic-ip-address 10.10.20.10 \
    --swarm \
    --engine-label app=1 \
    ${ROJ_MACHINE_OPTS} \
    ${ROJ_SWARM_NAME}-w10
```     

Test connection

```
eval $(docker-machine env --swarm ted-m1)
```


### References

https://docs.docker.com/swarm/install-manual/