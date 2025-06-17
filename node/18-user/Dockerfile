# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM node:18-bookworm

# Add Graphviz
RUN set -ex; \
  apt-get update -y; \
  apt-get install -y \
    graphviz \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    lsb-release \
    software-properties-common \
    git \
    jq \
    zip \
    ; \
  rm -rf /var/lib/apt/lists/*


# Install docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y  docker-ce docker-ce-cli containerd.io


# Setup protoc
RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v3.10.1/protoc-3.10.1-linux-x86_64.zip > /tmp/protoc-3.10.1-linux-x86_64.zip && \
    cd /usr/local && unzip /tmp/protoc-3.10.1-linux-x86_64.zip && rm -f /tmp/protoc-3.10.1-linux-x86_64.zip && \
    chmod -R o+rX /usr/local/include/google /usr/local/bin/protoc


# Install pyenv dependencies
RUN apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl

USER node

# Setup npm and ensure anyone can read/write to the global, shared config
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
RUN mkdir -p $NPM_CONFIG_PREFIX && chmod 777 $NPM_CONFIG_PREFIX
RUN npm config -g set update-notifier false
RUN npm i -g npm@`npm --version`

# Install pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    echo 'export PATH="/home/node/.pyenv/bin:$PATH"' >> ~/.profile && \
    echo 'export PATH="/home/node/.pyenv/shims:$PATH"' >> ~/.profile && \
    echo 'eval "$(pyenv init -)"' >> ~/.profile && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile

ENV PATH="/home/node/.pyenv/bin:/home/node/.pyenv/shims:/home/node/.npm-global/bin:${PATH}"

# Install python
RUN pyenv install 3.12.10 && \
    pyenv global 3.12.10 && \
    python3 -m pip install --upgrade pip setuptools

# Install gcp-uploader and gcp-releasetool and their dependencies.
COPY requirements.txt requirements.txt
RUN python3 -m pip install --require-hashes -r requirements.txt

# Setup Cloud SDK
WORKDIR /home/node
ENV CLOUD_SDK_VERSION=520.0.0 \
    CLOUDSDK_PYTHON=/home/node/.pyenv/shims/python3 \
    PATH=/home/node/google-cloud-sdk/bin:$PATH
RUN set -ex; \
    curl -LO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz; \
    tar xzf google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz; \
    rm google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN set -ex; \
    ./google-cloud-sdk/install.sh; \
    gcloud config set core/disable_usage_reporting true; \
    gcloud config set component_manager/disable_update_check true; \
    gcloud --quiet components update; \
    gcloud --quiet components install beta

WORKDIR /
