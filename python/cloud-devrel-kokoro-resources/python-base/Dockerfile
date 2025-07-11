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
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive

# Ensure local Python is preferred over distribution Python.
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# At the moment, setting "LANG=C" on a Linux system fundamentally breaks
# Python 3.
ENV LANG C.UTF-8

# Install dependencies.
RUN apt-get update \
  && apt -y upgrade \
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
    libffi-dev \
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
      A035C8C19219BA821ECEA86B64E628F8D684696D \
      # 3.12.x and 3.13.x (Thomas Wouters)
      7169605F62C751356D054A26A821E680E5FA6305

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
RUN for PYTHON_VERSION in 3.7.17 3.8.20 3.9.23 3.10.18 3.11.13 3.12.11 3.13.5; do \
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

# Install pip on Python 3.11
# If the environment variable is called "PIP_VERSION", pip explodes with
# "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 23.1.2
RUN wget --no-check-certificate -O /tmp/get-pip-3-7.py 'https://bootstrap.pypa.io/pip/3.7/get-pip.py' \
    && wget --no-check-certificate -O /tmp/get-pip-3-8.py 'https://bootstrap.pypa.io/pip/3.8/get-pip.py' \
    && wget --no-check-certificate -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
    && python3.11 /tmp/get-pip.py "pip==$PYTHON_PIP_VERSION" \

  # we use "--force-reinstall" for the case where the version of pip we're trying to install is the
  # same as the version bundled with Python
  # ("Requirement already up-to-date: pip==8.1.2 in /usr/local/lib/python3.6/site-packages")
  # https://github.com/docker-library/python/pull/143#issuecomment-241032683
    && pip3 install --no-cache-dir --upgrade --force-reinstall "pip==$PYTHON_PIP_VERSION" \

  # then we use "pip list" to ensure we don't have more than one pip version installed
  # https://github.com/docker-library/python/pull/100
    && [ "$(pip list |tac|tac| awk -F '[ ()]+' '$1 == "pip" { print $2; exit }')" = "$PYTHON_PIP_VERSION" ]

# Ensure Pip for all python3 versions
RUN python3.7 /tmp/get-pip-3-7.py
RUN python3.8 /tmp/get-pip-3-8.py
RUN python3.9 /tmp/get-pip.py
RUN python3.10 /tmp/get-pip.py
RUN python3.12 /tmp/get-pip.py
RUN python3.13 /tmp/get-pip.py

RUN rm /tmp/get-pip-3-7.py
RUN rm /tmp/get-pip-3-8.py
RUN rm /tmp/get-pip.py

# Remove setuptools installations for Python 3.7, 3.8
# since there is no fix for CVE-2025-47273/CVE-2025-47273.
# See https://github.com/python/cpython/issues/135374#issuecomment-2963361124
RUN for PYTHON_VERSION in 3.7 3.8; do \
    /usr/local/bin/python${PYTHON_VERSION} -m pip \
    uninstall -y \
    setuptools \
  ; done

# Upgrade setuptools installations for Python 3.9, 3.10 and 3.11
# for CVE-2025-47273/CVE-2025-47273.
# See https://github.com/python/cpython/issues/135374#issuecomment-2963361124
COPY requirements.txt /requirements.txt

RUN for PYTHON_VERSION in 3.9 3.10 3.11; do \
    /usr/local/bin/python${PYTHON_VERSION} -m pip \
    install \
    --no-cache-dir \
    --require-hashes \
    -r /requirements.txt \
  ; done

# Test Pip
RUN python3 -m pip
RUN python3.7 -m pip
RUN python3.8 -m pip
RUN python3.9 -m pip
RUN python3.10 -m pip
RUN python3.11 -m pip
RUN python3.12 -m pip
RUN python3.13 -m pip

CMD ["python3.11"]
