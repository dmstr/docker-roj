FROM schmunk42/docker-toolbox:6.0.0-beta2

# Install system packages
ENV TERM linux
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git \
        expect \
 && apt-get clean

# Install boilr
RUN curl -sSL https://raw.githubusercontent.com/tmrts/boilr/master/install | bash
ENV PATH /root/bin:${PATH}
RUN boilr init


# Add scripts and configuration
ENV PATH="/roj/bin:${PATH}"
ENV MACHINE_STORAGE_PATH /roj/config/machine
ENV DOCKER_CONFIG /roj/config

COPY ./src /

RUN mkdir /roj
WORKDIR /roj
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD bash


# Experimental(!) - Currently not available from DockerHub builds (TODO)
ARG BUILD_ROJ_VERSION
ENV ROJ_VERSION=${BUILD_ROJ_VERSION}
