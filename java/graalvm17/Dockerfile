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

ARG GRAALVM_VERSION

FROM ghcr.io/graalvm/graalvm-ce:ol7-java17-$GRAALVM_VERSION-b1

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
    wget -q https://services.gradle.org/distributions/gradle-7.3-bin.zip -O /tmp/gradle.zip && \
    mkdir -p /usr/local/lib/gradle && \
    unzip -q /tmp/gradle.zip -d /usr/local/lib/gradle && \
    rm /tmp/gradle.zip

ENV PATH $PATH:/usr/local/lib/maven/bin:/usr/local/lib/gradle/gradle-7.3/bin

# Install gcloud SDK
COPY google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
RUN yum install -y google-cloud-sdk

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install docker
RUN yum install -y docker-engine docker-cli

# Install terraform
RUN yum -y install terraform

# Install jq
RUN yum -y install jq

# Install chrome dependencies.
RUN echo "Y" | apt install libnss3
RUN echo "Y" | apt install libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev libgconf-2-4

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
