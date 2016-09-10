# рой (roj)

Portable environments for Docker swarms and stacks

## About

Roj is based on native Docker tools to build swarms with `docker-machine` and manage stacks with `docker-compose`. 
Since all tools are run from a docker container, the created configurations (on a host-volume) remain portable.

## Getting started

- define your desired configuration directory as a host-volume in `docker-compose.yml`
- define environment configuration in `config/env`
- start management container `docker-compose run roj`

## Documentation

- [Build a swarm with the generic driver](docs/setup-generic-swarm.md)

## References

- https://docs.docker.com/swarm/install-manual/

---

#### ![dmstr logo](http://t.phundament.com/dmstr-16-cropped.png) Built by [dmstr](http://diemeisterei.de)