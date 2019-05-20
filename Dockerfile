FROM schmunk42/docker-toolbox:9.0.0-rc1

# Install gnupg2
ENV TERM linux
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        gnupg2 \
 && apt-get clean

# Create an environment variable for the correct distribution
# Add the Cloud SDK distribution URI as a package source
RUN export CLOUD_SDK_REPO="cloud-sdk-jessie" \
 && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Install system packages (including aws, gcloud)
ENV TERM linux
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git \
        expect \
        awscli \
        google-cloud-sdk \
        less \
        rsync \
        watch \
 && apt-get clean

# Install boilr
RUN curl -sSL https://raw.githubusercontent.com/tmrts/boilr/master/install | bash
ENV PATH /root/bin:${PATH}
RUN boilr init

# Install ctop
RUN curl -L https://github.com/bcicen/ctop/releases/download/v0.6.1/ctop-0.6.1-linux-amd64 -o ctop
RUN mv ctop /usr/local/bin/
RUN chmod +x /usr/local/bin/ctop

# install current version of awscli (deb pkg version is way too old)
RUN curl -o get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py
RUN pip install --upgrade awscli

# Install jsonfui
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install nodejs \
 && npm install -g jsonfui

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
