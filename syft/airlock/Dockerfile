# Copyright 2025 Google LLC
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

# ubuntu:24.04 as of May 14, 2025
FROM us-docker.pkg.dev/artifact-foundry-prod/standard-docker-3p-l1/ubuntu@sha256:80dd3c3b9c6cecb9f1667e9290b3bc61b78c2678c02cbdae5f0fea92cc6734ab as bootstrap

RUN apt-get update && \
    apt-get install --no-install-recommends -y --allow-change-held-packages \
        gnupg curl ca-certificates apt-utils && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo 'deb http://packages.cloud.google.com/apt apt-transport-artifact-registry-stable main' | tee -a /etc/apt/sources.list.d/artifact-registry.list

RUN apt-get update && apt-get install apt-transport-artifact-registry

# New clean base so we aren't fetching "gnupg curl apt-utils" if not needed
FROM us-docker.pkg.dev/artifact-foundry-prod/standard-docker-3p-l1/ubuntu@sha256:80dd3c3b9c6cecb9f1667e9290b3bc61b78c2678c02cbdae5f0fea92cc6734ab as base

# ca-certificates is required for https
RUN apt-get update && \
    apt-get install --no-install-recommends -y --allow-change-held-packages \
        ca-certificates

# Copy only the ar+https
COPY --from=bootstrap "/usr/lib/apt/methods/ar+https" "/usr/lib/apt/methods/ar+https"
# Copy the apache notice type license for OSPO
COPY --from=bootstrap "/usr/share/doc/apt-transport-artifact-registry" "/usr/share/doc/apt-transport-artifact-registry"

# Remove all other apt sources, silence errors if file doesn't exist
RUN rm -f /etc/apt/sources.list.d/* /etc/apt/sources.list

# If GOOGLE_APPLICATION_CREDENTIALS is passed in docker build command use it, if not leave it unset to support GCE Metadata in CI builds
ARG GOOGLE_APPLICATION_CREDENTIALS

# Use a secret mount to access your long lived credentials, without the risk of leaking them in any of the docker layers
RUN --mount=type=secret,id=credentials \
    echo 'deb ar+https://us-apt.pkg.dev/remote/artifact-foundry-prod/ubuntu-3p-remote-noble noble main' | \
    tee -a  /etc/apt/sources.list.d/artifact-registry.list && \
    apt update

# Everything after this is for your image, if you build FROM a base image with airlock already configured

ENV SYFT_VERSION=1.19.0

# Install packages you require that need auth
RUN --mount=type=secret,id=credentials \
    apt-get update -y && \
    apt-get install -y \
        ca-certificates \
        curl \
        uuid-runtime \
        git \
        jq \
        zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /workspace

WORKDIR /workspace

ADD https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_amd64.deb /workspace/syft.deb
RUN dpkg -i syft.deb

ENTRYPOINT ["syft"]
