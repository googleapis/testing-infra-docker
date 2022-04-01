# Copyright 2021 Google LLC
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

FROM ghcr.io/graalvm/graalvm-ce:ol7-java11-22.0.0.2

RUN gu install native-image && \
    yum update -y && \
    yum install -y wget unzip git && \
    # Install maven, do not upgrade to 3.8.2
    wget -q https://archive.apache.org/dist/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.zip -O /tmp/maven.zip && \
    unzip /tmp/maven.zip -d /tmp/maven && \
    mv /tmp/maven/apache-maven-3.8.1 /usr/local/lib/maven && \
    rm /tmp/maven.zip && \
    ln -s $JAVA_HOME/lib $JAVA_HOME/conf && \
    # Install Gradle
    wget -q https://services.gradle.org/distributions/gradle-4.9-bin.zip -O /tmp/gradle.zip && \
    mkdir -p /usr/local/lib/gradle && \
    unzip -q /tmp/gradle.zip -d /usr/local/lib/gradle && \
    rm /tmp/gradle.zip

ENV PATH $PATH:/usr/local/lib/maven/bin:/usr/local/lib/gradle/gradle-4.9/bin

# Install gcloud SDK
COPY google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
RUN yum install -y google-cloud-sdk

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install docker
RUN apt-get update && apt-get install -y \
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

WORKDIR /workspace
