# syntax = edrevo/dockerfile-plus

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

# The file is copied by the previous step in Cloud Build yaml file
INCLUDE+ Dockerfile.ubuntu-bookworm.airlock

# openjdk:8-jdk as of January 23th, 2025
FROM us-docker.pkg.dev/artifact-foundry-prod/docker-3p-trusted/openjdk@sha256:3af2ac94130765b73fc8f1b42ffc04f77996ed8210c297fcfa28ca880ff0a217

# TODO(suztomo): Update this to source them from Airlock
RUN --mount=type=secret,id=credentials apt-get update && \
    apt-get -y upgrade && \
    apt-get install -v -y --no-install-recommends libxml2-utils apt-transport-https ca-certificates gnupg && \
    rm -rf /var/cache/apt

ENV MAVEN_HOME=/usr/share/maven
# 3.9.9-eclipse-temurin-11-alpine
COPY --from=us-docker.pkg.dev/artifact-foundry-prod/docker-3p-trusted/maven@sha256:d3f04985c6a68415e36c0a6468d0f8316f27d4dbee77bc459257ba444224bd9f ${MAVEN_HOME} ${MAVEN_HOME}

# TODO(suztomo): Do we use Gradle?
RUN wget -q https://services.gradle.org/distributions/gradle-4.9-bin.zip -O /tmp/gradle.zip && \
    mkdir -p /usr/local/lib/gradle && \
    unzip -q /tmp/gradle.zip -d /usr/local/lib/gradle && \
    rm /tmp/gradle.zip

ENV PATH $PATH:${MAVEN_HOME}/bin:/usr/local/lib/gradle/gradle-4.9/bin

# Install gcloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && apt-get update -y && \
    apt-get install -v google-cloud-sdk -y

# Install google-play-services version 1
RUN mkdir -p /tmp/playservices && \
    wget -q https://dl.google.com/dl/android/maven2/com/google/android/gms/play-services-basement/8.3.0/play-services-basement-8.3.0.aar -O /tmp/play-services-basement.aar && \
    unzip -q /tmp/play-services-basement.aar -d /tmp/playservices && \
    mvn -V install:install-file \
        -Dfile=/tmp/playservices/classes.jar \
        -DgroupId=com.google.android.google-play-services \
        -DartifactId=google-play-services \
        -Dversion=1 \
        -Dpackaging=jar

# Install the appengine SDK
RUN mvn -V dependency:get -Dartifact=com.google.appengine:appengine-api-1.0-sdk:1.9.65

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install pyenv
RUN --mount=type=secret,id=credentials \
    apt-get install -v -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

ENV PATH /root/.pyenv/bin:$PATH
ENV PATH /root/.pyenv/shims:$PATH

RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> .bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> .bashrc && \
    echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

# Install python
RUN pyenv install 3.9.13 && \
    pyenv global 3.9.13 && \
    python3 -m pip install --upgrade pip setuptools

# Install docker
RUN --mount=type=secret,id=credentials \
    apt-get update && apt-get install -v -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        lsb-release \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Terraform
RUN --mount=type=secret,id=credentials \
    apt-get update && apt-get install -v -y gnupg software-properties-common curl && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install terraform

# jq and xmlstarlet used to modify json and xml files
RUN --mount=type=secret,id=credentials \
    apt-get -y install -v jq
RUN --mount=type=secret,id=credentials \
    apt-get -y install -v xmlstarlet

# Installing JDK 11 to build projects that depend on graal-sdk 22.1.0 or higher
# (requiring Java 11+). Still we target Java 8 for the compiled class files.
RUN --mount=type=secret,id=credentials \
    apt-get install -v -y openjdk-11-jdk
# JDK 11 is used only when explicitly selected in the build file
ENV JAVA8_HOME=/usr/local/openjdk-8
ENV JAVA11_HOME=/usr/lib/jvm/java-11-openjdk-amd64

WORKDIR /workspace
