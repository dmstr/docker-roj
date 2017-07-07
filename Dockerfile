FROM schmunk42/docker-toolbox:6.1.0-rc1

# Install system packages
ENV TERM linux
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git \
        expect \
        less \
 && apt-get clean

# Install boilr
RUN curl -sSL https://raw.githubusercontent.com/tmrts/boilr/master/install | bash
ENV PATH /root/bin:${PATH}
RUN boilr init

# Install ctop
RUN curl -L https://github.com/bcicen/ctop/releases/download/v0.4.1/ctop-0.4.1-linux-amd64 -o ctop
RUN mv ctop /usr/local/bin/
RUN chmod +x /usr/local/bin/ctop

# install current version of awscli, deb pkg version is way to old
RUN pip install --upgrade awscli

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
