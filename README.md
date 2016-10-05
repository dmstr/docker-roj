# рой (roj)

Portable environments for Docker swarms and stacks

## About

Roj is based on native Docker tools to build swarms with `docker-machine` and manage stacks with `docker-compose`. 
Since all tools are run from a docker container the created configurations, stored under `/roj` in the container and mounted 
from on a host-volume, remain portable.

## Requirements

- access to hosts/VMs via SSH keys or 
- credentials to create machines in the cloud (see `docker-machine` drivers)

## Getting started

- define your desired configuration directory as a host-volume in `docker-compose.yml`
- define environment configuration in `config/env`
- start management container `docker-compose run roj`
- use `$ docker-machine` to create machines and provision discovery and a swarm
- use `$ docker-compose` to run stacks

## Documentation

- [Build a swarm with the generic driver](./docs/setup-generic-swarm.md)
- [FAQ & troubleshooting](./docs/faq-troubleshooting.md)

## References

- https://docs.docker.com/swarm/install-manual/
- https://docs.docker.com/compose/swarm
- https://github.com/docker/swarm#swarm-disambiguation
- https://docs.docker.com/compose/production/

---

#### ![dmstr logo](http://t.phundament.com/dmstr-16-cropped.png) Built by [dmstr](http://diemeisterei.de)
