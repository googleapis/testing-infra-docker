# Copyright 2018 Google LLC
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

FROM node:16-stretch

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
    ; \
  rm -rf /var/lib/apt/lists/*

# Install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Setup protoc
RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v3.10.1/protoc-3.10.1-linux-x86_64.zip > /tmp/protoc-3.10.1-linux-x86_64.zip && \
    cd /usr/local && unzip /tmp/protoc-3.10.1-linux-x86_64.zip && rm -f /tmp/protoc-3.10.1-linux-x86_64.zip && \
    chmod -R o+rX /usr/local/include/google /usr/local/bin/protoc

USER node

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
RUN ls -lah ~/

RUN echo 'export PATH="/home/node/.pyenv/bin:$PATH"' >> ~/.profile
RUN echo 'export PATH="/home/node/.pyenv/shims:$PATH"' >> ~/.profile
RUN echo 'eval "$(pyenv init -)"' >> ~/.profile
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile

ENV PATH="/home/node/.pyenv/bin:/home/node/.pyenv/shims:${PATH}"

RUN pyenv install 3.7.1
RUN pyenv global 3.7.1

# Setup Cloud SDK
WORKDIR /home/node
ENV CLOUD_SDK_VERSION=261.0.0 \
    CLOUDSDK_PYTHON=/usr/bin/python \
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
