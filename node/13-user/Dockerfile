# Copyright 2019 Google LLC
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

FROM node:13-stretch

# Add Graphviz
RUN set -ex; \
  apt-get update -y; \
  apt-get install -y \
    graphviz \
    ; \
  rm -rf /var/lib/apt/lists/*

# Setup protoc
RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v3.10.1/protoc-3.10.1-linux-x86_64.zip > /tmp/protoc-3.10.1-linux-x86_64.zip && \
    cd /usr/local && unzip /tmp/protoc-3.10.1-linux-x86_64.zip && rm -f /tmp/protoc-3.10.1-linux-x86_64.zip && \
    chmod -R o+rX /usr/local/include/google /usr/local/bin/protoc

USER node

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

RUN echo 'export PATH="/home/node/.pyenv/bin:$PATH"' >> ~/.profile
RUN echo 'export PATH="/home/node/.pyenv/shims:$PATH"' >> ~/.profile
RUN echo 'eval "$(pyenv init -)"' >> ~/.profile
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile

ENV PATH="/home/node/.pyenv/bin:/home/node/.pyenv/shims:${PATH}"

RUN pyenv install 3.7.4
RUN pyenv global 3.7.4

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
