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

FROM openjdk:11-jdk

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends libxml2-utils apt-transport-https ca-certificates gnupg zip unzip && \
    rm -rf /var/cache/apt

RUN wget -q https://archive.apache.org/dist/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.zip -O /tmp/maven.zip && \
    unzip /tmp/maven.zip -d /tmp/maven && \
    mv /tmp/maven/apache-maven-3.8.1 /usr/local/lib/maven && \
    rm /tmp/maven.zip && \
    ln -s $JAVA_HOME/lib $JAVA_HOME/conf

RUN wget -q https://services.gradle.org/distributions/gradle-4.9-bin.zip -O /tmp/gradle.zip && \
    mkdir -p /usr/local/lib/gradle && \
    unzip -q /tmp/gradle.zip -d /usr/local/lib/gradle && \
    rm /tmp/gradle.zip

ENV PATH $PATH:/usr/local/lib/maven/bin:/usr/local/lib/gradle/gradle-4.9/bin

# Install gcloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && apt-get update -y && \
    apt-get install google-cloud-sdk -y

# Install google-play-services version 1
RUN mkdir -p /tmp/playservices && \
    wget -q https://dl.google.com/dl/android/maven2/com/google/android/gms/play-services-basement/8.3.0/play-services-basement-8.3.0.aar -O /tmp/play-services-basement.aar && \
    unzip -q /tmp/play-services-basement.aar -d /tmp/playservices && \
    mvn install:install-file \
        -Dfile=/tmp/playservices/classes.jar \
        -DgroupId=com.google.android.google-play-services \
        -DartifactId=google-play-services \
        -Dversion=1 \
        -Dpackaging=jar

# Install the appengine SDK
RUN mvn dependency:get -Dartifact=com.google.appengine:appengine-api-1.0-sdk:1.9.65

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install pyenv
RUN apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
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

# Add Graphviz
RUN apt-get update -y && \
    apt-get install -y graphviz && \
    rm -rf /var/lib/apt/lists/*
    
# Add imagemagick
RUN apt-get update -y && \
    apt-get install -y imagemagick && \
    rm -rf /var/lib/apt/lists/*

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

# Install Terraform
RUN apt-get update && apt-get install -y gnupg software-properties-common curl && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install terraform

# jq and xmlstarlet used to modify json and xml files
RUN apt-get -y install jq
RUN apt-get -y install xmlstarlet

# Install chrome dependencies.
RUN echo "Y" | apt install libnss3 \
  && echo "Y" | apt install libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev libgconf-2-4 \
  && rm -rf /var/lib/apt/lists/*

# Install Chrome.
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub -o /tmp/google.pub \
  && cat /tmp/google.pub | apt-key add -; rm /tmp/google.pub \
  && echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list \
  && mkdir -p /usr/share/desktop-directories \
  && apt-get -y update && apt-get install -y google-chrome-stable

# Disable the SUID sandbox so that Chrome can launch without being in a privileged container.
RUN dpkg-divert --add --rename --divert /opt/google/chrome/google-chrome.real /opt/google/chrome/google-chrome \
  && echo "#!/bin/bash\nexec /opt/google/chrome/google-chrome.real --no-sandbox --disable-setuid-sandbox \"\$@\"" > /opt/google/chrome/google-chrome \
  && chmod 755 /opt/google/chrome/google-chrome \
  && ln -fs /opt/google/chrome/google-chrome /usr/bin/google-chrome

# Install chrome driver.
RUN mkdir -p /opt/selenium \
  && curl http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip -o /opt/selenium/chromedriver_linux64.zip \
  && cd /opt/selenium; unzip /opt/selenium/chromedriver_linux64.zip; rm -rf chromedriver_linux64.zip; ln -fs /opt/selenium/chromedriver /usr/local/bin/chromedriver;

WORKDIR /workspace
