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

FROM ubuntu:14.10

RUN apt-get update -q && apt-get install -y software-properties-common && apt-get clean
RUN add-apt-repository -y ppa:fkrull/deadsnakes
RUN apt-get -y update && \
    apt-get -y install \
        git wget curl \
        python-pip python-dev python3-dev python3.5 python3.5-dev python3.6 python3.6-dev \
        openjdk-7-jre openjdk-7-jdk maven \
        libffi-dev libssl-dev libxml2-dev \
        libxslt1-dev libpq-dev libmysqlclient-dev libcurl4-openssl-dev \
        libjpeg-dev zlib1g-dev libpng12-dev python-pyaudio \
        libmemcached-dev && \
    apt-get clean

RUN pip install tox

# Setup Cloud SDK
ENV CLOUD_SDK_VERSION 146.0.0
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN tar xzf google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN /google-cloud-sdk/install.sh
ENV PATH /google-cloud-sdk/bin:$PATH
