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
# features are available.
FROM ubuntu:20.04

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
    dirmngr \
    git \
    gpg-agent \
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

# https://github.com/f-secure-foundry/usbarmory-debian-base_image/issues/9
RUN mkdir /tmp/gpg \
&& echo "disable-ipv6" >> /tmp/gpg/dirmngr.conf

ENV GNUPGHOME /tmp/gpg
# Fetch keys for verifying python installations
# Do this early so the build fails quickly if the keyserver is unavailable
# Consider one of the alternatives here if this continues to be flaky:
# https://github.com/docker-library/faq#openpgp--gnupg-keys-and-verification
# See https://www.python.org/downloads/ 'OpenPGP Public Keys' for new keys.
# The hashes below are the fingerprints for the keys of the key signers
# and are not specific to any version of Python
RUN set -ex \
  && gpg --keyserver keyserver.ubuntu.com --recv-keys \
      # 3.6.x, 3.7.x (Ned Deily)
      0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D \
      # 3.8.x and 3.9.x (Łukasz Langa)
      E3FF2839C048B25C084DEBE9B26995E310250568 \
      # 3.10.x and 3.11.x (Pablo Galindo Salgado)
      A035C8C19219BA821ECEA86B64E628F8D684696D

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

# Install the desired versions of Python.
RUN for PYTHON_VERSION in 3.7.17 3.8.17 3.9.17 3.10.12 3.11.4; do \
  set -ex \
    && wget --quiet --no-check-certificate -O python-${PYTHON_VERSION}.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
    && wget --quiet --no-check-certificate -O python-${PYTHON_VERSION}.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
    && gpg --batch --verify python-${PYTHON_VERSION}.tar.xz.asc python-${PYTHON_VERSION}.tar.xz \
    && rm -r python-${PYTHON_VERSION}.tar.xz.asc \
    && mkdir -p /usr/src/python-${PYTHON_VERSION} \
    && tar -xJC /usr/src/python-${PYTHON_VERSION} --strip-components=1 -f python-${PYTHON_VERSION}.tar.xz \
    && rm python-${PYTHON_VERSION}.tar.xz \
    && cd /usr/src/python-${PYTHON_VERSION} \
    && ./configure \
        --enable-shared \
        --with-system-ffi \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
  ; done \
  && rm -rf /usr/src/python* \
  && rm -rf ~/.cache/ \
  && rm -r "$GNUPGHOME"

# Make sure the Python 3 version of pip is up-to-date and install
# python packages
COPY requirements.txt /requirements.txt

RUN /usr/local/bin/python3 -m pip install --upgrade pip
RUN /usr/local/bin/python3 -m pip \
  install \
  --no-cache-dir \
  --require-hashes \
  -r /requirements.txt

CMD ["python3.11"]
