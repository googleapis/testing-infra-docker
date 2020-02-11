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

# Dockerfile derived from googleapis/python-multi (the image used by the client
# libraries tests). We modify this to ensure that all standard library
# features are available and only build Python 2.7 and 3.6.
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# Ensure local Python is preferred over distribution Python.
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# At the moment, setting "LANG=C" on a Linux system fundamentally breaks
# Python 3.
ENV LANG C.UTF-8

# Install dependencies.
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    bzip2 \
    ca-certificates \
    curl \
    git \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    software-properties-common \
    ssh \
    sudo \
    tcl \
    tcl-dev \
    tk \
    tk-dev \
    wget \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f /var/cache/apt/archives/*.deb

# Install the desired versions of Python.
RUN for PYTHON_VERSION in 2.7.14 3.6.3; do \
  set -ex \
    && wget -O python-${PYTHON_VERSION}.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
    && mkdir -p /usr/src/python-${PYTHON_VERSION} \
    && tar -xJC /usr/src/python-${PYTHON_VERSION} --strip-components=1 -f python-${PYTHON_VERSION}.tar.xz \
    && rm python-${PYTHON_VERSION}.tar.xz \
    && cd /usr/src/python-${PYTHON_VERSION} \
    && ./configure \
        --enable-shared \
        --enable-optimizations \
      # This works only on Python 2.7 and throws a warning on every other
      # version, but seems otherwise harmless.
        --enable-unicode=ucs4 \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
  ; done \
  && rm -rf /usr/src/python* \
  && rm -rf ~/.cache/

# Make sure the Python 3 version of pip is up-to-date and install virtualenv
RUN /usr/local/bin/python3 -m pip \
  install \
  --no-cache-dir \
  --upgrade \
  pip \
  virtualenv

# Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    docker-ce \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f /var/cache/apt/archives/*.deb

CMD ["python3.6"]
