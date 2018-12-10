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

FROM openjdk:7-jdk

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends libxml2-utils && \
    rm -rf /var/cache/apt

RUN wget -q http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz -O /tmp/maven.tar.gz && \
    mkdir -p /usr/local/lib/maven && \
    tar xzf /tmp/maven.tar.gz -C /usr/local/lib/maven --strip-components=1 && \
    rm /tmp/maven.tar.gz && \
    ln -s $JAVA_HOME/lib $JAVA_HOME/conf

RUN wget -q https://services.gradle.org/distributions/gradle-4.9-bin.zip -O /tmp/gradle.zip && \
    mkdir -p /usr/local/lib/gradle && \
    unzip -q /tmp/gradle.zip -d /usr/local/lib/gradle && \
    rm /tmp/gradle.zip

ENV PATH $PATH:/usr/local/lib/maven/bin:/usr/local/lib/gradle/gradle-4.9/bin

# Install gcloud SDK
RUN mkdir -p /usr/local/gcloud && \
    curl -sSL https://sdk.cloud.google.com | bash -s -- --install-dir=/usr/local/gcloud

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

# Fix security for Java 7 (https://github.com/travis-ci/travis-ci/issues/8503)
# RUN wget -q "https://bouncycastle.org/download/bcprov-ext-jdk15on-158.jar" -O "${JAVA_HOME}"/jre/lib/ext/bcprov-ext-jdk15on-158.jar && \
#     perl -pi.bak -e 's/^(security\.provider\.)([0-9]+)/$1.($2+1)/ge' /etc/java-7-openjdk/security/java.security && \
#     echo "security.provider.1=org.bouncycastle.jce.provider.BouncyCastleProvider" | tee -a /etc/java-7-openjdk/security/java.security

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

WORKDIR /workspace
