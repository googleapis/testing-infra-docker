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

# Step 1: create a core image with hex and rebar installed
ARG BASE_IMAGE
FROM ${BASE_IMAGE} as core

RUN mix local.rebar --force && \
    mix local.hex --force

ENTRYPOINT []
CMD ["/bin/bash"]

# Step 2: build the elixir and erlang core plt files
FROM core AS plt-builder

ARG SHORT_VERSION

RUN mkdir -p /opt/plt_builder
WORKDIR /opt/plt_builder
COPY plt_builder /opt/plt_builder

RUN cp plts/elixir${SHORT_VERSION}/*.plt /root/.mix ; \
    mix do deps.get, dialyzer --plt

# Step 3: build the testing images with the pre-build plt files
FROM core

ARG NODEJS_VERSION=12.13.0

COPY --from=plt-builder /root/.mix /root/.mix

RUN mkdir -p /opt/nodejs && \
    curl -s https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz \
        | tar xzf - --directory=/opt/nodejs --strip-components=1 && \
    mkdir -p /opt/docker/bin && \
    curl -sL https://download.docker.com/linux/static/stable/x86_64/docker-19.03.4.tgz \
        | tar xzf - --directory=/opt/docker/bin --strip-components=1

ENV PATH=/opt/nodejs/bin:/opt/docker/bin:$PATH
