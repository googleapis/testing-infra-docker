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

FROM adoptopenjdk:8-jdk

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y libxml2-utils make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl graphviz imagemagick unzip git \
    apt-transport-https ca-certificates gnupg-agent lsb-release software-properties-common && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://mirrors.advancedhosters.com/apache/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz -o /tmp/maven.tar.gz && \
    mkdir -p /usr/local/lib/maven && \
    tar xzf /tmp/maven.tar.gz -C /usr/local/lib/maven --strip-components=1 && \
    rm /tmp/maven.tar.gz && \
    ln -s $JAVA_HOME/lib $JAVA_HOME/conf

RUN curl -sSL https://services.gradle.org/distributions/gradle-6.9-bin.zip -o /tmp/gradle.zip && \
    mkdir -p /usr/local/lib/gradle && \
    unzip -q /tmp/gradle.zip -d /usr/local/lib/gradle && \
    rm /tmp/gradle.zip

ENV PATH $PATH:/usr/local/lib/maven/bin:/usr/local/lib/gradle/gradle-6.9/bin

# Install gcloud SDK
RUN mkdir -p /usr/local/gcloud && \
    curl -sSL https://sdk.cloud.google.com | bash -s -- --install-dir=/usr/local/gcloud

# Install google-play-services version 1
RUN mkdir -p /tmp/playservices && \
    curl -sSL https://dl.google.com/dl/android/maven2/com/google/android/gms/play-services-basement/8.3.0/play-services-basement-8.3.0.aar -o /tmp/play-services-basement.aar && \
    unzip -q /tmp/play-services-basement.aar -d /tmp/playservices && \
    mvn install:install-file \
        -Dfile=/tmp/playservices/classes.jar \
        -DgroupId=com.google.android.google-play-services \
        -DartifactId=google-play-services \
        -Dversion=1 \
        -Dpackaging=jar

# Install the appengine SDK
RUN mvn dependency:get -Dartifact=com.google.appengine:appengine-api-1.0-sdk:1.9.90

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

ENV PATH /root/.pyenv/shims:/root/.pyenv/bin:$PATH

RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> .bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> .bashrc && \
    echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

# Install python
RUN pyenv install 3.6.12 && \
    pyenv global 3.6.12 && \
    python3 -m pip install --upgrade pip setuptools

# Install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io
WORKDIR /workspace
