# Copyright 2018 Google LLCRG
# 
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

# The file is copied by the previous step in Cloud Build yaml file
# INCLUDE+ Dockerfile.ubuntu-bookworm.airlock

# openjdk:8-jdk as of January 23th, 2025
FROM us-docker.pkg.dev/artifact-foundry-prod/docker-3p-trusted/openjdk@sha256:3af2ac94130765b73fc8f1b42ffc04f77996ed8210c297fcfa28ca880ff0a217 as mybootstrap

RUN apt-get update && \
    apt-get install --no-install-recommends -y --allow-change-held-packages \
        gnupg curl ca-certificates apt-utils && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo 'deb http://packages.cloud.google.com/apt apt-transport-artifact-registry-stable main' | tee -a /etc/apt/sources.list.d/artifact-registry.list

RUN apt-get update && apt-get install apt-transport-artifact-registry

# ca-certificates is required for https
RUN apt-get update && \
    apt-get install --no-install-recommends -y --allow-change-held-packages \
        ca-certificates

# Remove all other apt sources, silence errors if file doesn't exist
RUN rm -f /etc/apt/sources.list.d/* /etc/apt/sources.list

# If GOOGLE_APPLICATION_CREDENTIALS is passed in docker build command use it, if not leave it unset to support GCE Metadata in CI builds
ARG GOOGLE_APPLICATION_CREDENTIALS

# You can override the repository URL with:
# --build-arg="APT_REPO=ar+https://us-apt.pkg.dev/remote/artifact-foundry-prod/debian-3p-remote-bullseye bullseye main" .
# This is convinient when you want to pass a special Airlock repository
# that initiates software package imports.
ARG APT_REPO="ar+https://us-apt.pkg.dev/projects/artifact-foundry-prod standard-debian-bullseye-3p-l1 main"

# The container image is "bullseye". So use matching configuration from:
# go/airlock/howto_debian?DEBIAN_REPOSITORY=bullseye&APT_REPOSITORY=bullseye-3p-l1#apt-debian-standard-repositories
RUN --mount=type=secret,id=credentials \
    echo "deb ${APT_REPO}" | \
    tee -a  /etc/apt/sources.list.d/artifact-registry.list && \
    apt-get update

RUN --mount=type=secret,id=credentials \
    apt install -y python3.9 python3-pip

RUN python3 --version
# Install python setuptools
RUN python3 -m pip install setuptools

# Everything after this is for your image, if you build FROM a base image with Airlock already configured
RUN --mount=type=secret,id=credentials \
    apt install -y --no-install-recommends libxml2-utils apt-transport-https ca-certificates gnupg

ENV MAVEN_HOME=/usr/share/maven
# 3.9.9-eclipse-temurin-11-alpine
COPY --from=us-docker.pkg.dev/artifact-foundry-prod/docker-3p-trusted/maven@sha256:d3f04985c6a68415e36c0a6468d0f8316f27d4dbee77bc459257ba444224bd9f ${MAVEN_HOME} ${MAVEN_HOME}

ENV PATH $PATH:${MAVEN_HOME}/bin

# jq and xmlstarlet used to modify json and xml files
RUN --mount=type=secret,id=credentials \
    apt-get -y install jq
RUN --mount=type=secret,id=credentials \
    apt-get -y install xmlstarlet

# Installing JDK 11 to build projects that depend on graal-sdk 22.1.0 or higher
# (requiring Java 11+). Still we target Java 8 for the compiled class files.
RUN --mount=type=secret,id=credentials \
    apt-get install -y openjdk-11-jdk
# JDK 11 is used only when explicitly selected in the build file
ENV JAVA8_HOME=/usr/local/openjdk-8
ENV JAVA11_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# TODO(b/390675031) The following packages are still downloading outside Airlock

# Install gcloud SDK
RUN --mount=type=secret,id=credentials \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && apt-get update -y && \
    apt install -y google-cloud-sdk

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

WORKDIR /workspace
