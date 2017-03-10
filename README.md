# рой (roj)

Portable environments for Docker swarms and Compose applications

## About

Roj is based on native Docker tools to build swarms with `docker-machine` and manage stacks with `docker-compose`. 
Since all tools are run from a docker container the created configurations, stored under `/roj` in the container and mounted 
from on a host-volume, remain portable.

You can use portainer as 

## Requirements

On your host

- docker `>=1.9`
- docker-compose (optional) `>=1.8`

For remote machine access

- access to hosts/VMs via SSH keys or 
- credentials to create machines in the cloud (see `docker-machine` drivers)

## Getting started

Create a new directory for your roj-stacks project and add a `docker-compose.yml` with the following contents

    roj:
      image: dmstr/roj:0.3.0-beta1
      working_dir: /roj
      volumes:
        - ./roj:/roj

> By default swarm & stack configuration files will be placed into `./roj`, change your desired configuration directory by updating the host-volume path on your machine.

Run the roj management container

    docker-compose run --rm roj

And create files from a *boilr*-template

    $ boilr template download schmunk42/roj-stacks-template stacks    
    $ boilr template use stacks .

You can always update environment configuration in `config/env` if needed, a management container restart is required after changing ENV variables.

TODO: Create SSH key

> :bulb: Check out the [docs section](docs/) for specific host and/or provider requirements.

## Usage

From the management container...

Use `$ docker-machine` to create machines and provision discovery and a swarm.

Use `$ docker-compose` to run stacks

## Documentation

- [Build a swarm with the generic driver](./docs/setup-generic-swarm.md)
- [Build a swarm on AWS](./docs/setup-aws-swarm.md)
- [FAQ & troubleshooting](./docs/faq-troubleshooting.md)

## Screenshots

### Startup

![roj-startup](https://raw.githubusercontent.com/dmstr/gh-media/master/dmstr/docker-roj/roj-startup.png)

### Green-blue redeployment

![roj-redeploy](https://raw.githubusercontent.com/dmstr/gh-media/master/dmstr/docker-roj/roj-redeploy.png)

## References

- https://docs.docker.com/swarm/install-manual/
- https://docs.docker.com/compose/swarm
- https://github.com/docker/swarm#swarm-disambiguation
- https://docs.docker.com/compose/production/

## Resources

- :octocat: [`dmstr/docker-roj`](https://github.com/dmstr/docker-roj)
- :wolf: [`dmstr/docker-roj`](https://git.hrzg.de/dmstr/docker-roj)
- :whale: [`dmstr/roj`](https://hub.docker.com/r/dmstr/roj/)


---

#### ![dmstr logo](http://t.phundament.com/dmstr-16-cropped.png) Built by [dmstr](http://diemeisterei.de)
