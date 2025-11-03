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
FROM marketplace.gcr.io/google/ubuntu2404

ENV DEBIAN_FRONTEND=noninteractive

# Ensure local Python is preferred over distribution Python.
ENV PATH=/usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# At the moment, setting "LANG=C" on a Linux system fundamentally breaks
# Python 3.
ENV LANG=C.UTF-8

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

# From https://www.python.org/downloads/metadata/sigstore/
# Starting with Python 3.14, Sigstore is the only method of signing and verification of release artifacts. 
RUN LATEST_VERSION="2.6.1" && \
    wget "https://github.com/sigstore/cosign/releases/download/v${LATEST_VERSION}/cosign_${LATEST_VERSION}_amd64.deb" && \
    dpkg -i cosign_${LATEST_VERSION}_amd64.deb && \
    rm cosign_${LATEST_VERSION}_amd64.deb

ARG PYTHON_VERSIONS="3.9.24 3.10.19 3.11.14 3.12.12 3.13.9 3.14.0"

SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    # Define the required associative arrays completely.
    declare -A PYTHON_IDENTITIES; \
    PYTHON_IDENTITIES=(\
        [3.9]="lukasz@langa.pl" \
        [3.10]="pablogsal@python.org" \
        [3.11]="pablogsal@python.org" \
        [3.12]="thomas@python.org" \
        [3.13]="thomas@python.org" \
        [3.14]="hugo@python.org" \
    ); \
    declare -A PYTHON_ISSUERS; \
    PYTHON_ISSUERS=(\
        [3.9]="https://github.com/login/oauth" \
        [3.10]="https://accounts.google.com" \
        [3.11]="https://accounts.google.com" \
        [3.12]="https://accounts.google.com" \
        [3.13]="https://accounts.google.com" \
        [3.14]="https://github.com/login/oauth" \
    ); \
    \
    for VERSION in $PYTHON_VERSIONS; do \
        # 1. Define VERSION_GROUP (e.g., 3.14 from 3.14.0)
        VERSION_GROUP="$(echo "${VERSION}" | cut -d . -f 1,2)"; \
        \
        # 2. Look up IDENTITY and ISSUER using the defined VERSION_GROUP
        IDENTITY="${PYTHON_IDENTITIES[$VERSION_GROUP]}"; \
        ISSUER="${PYTHON_ISSUERS[$VERSION_GROUP]}"; \
        \
      wget --quiet -O python-${VERSION}.tar.xz "https://www.python.org/ftp/python/${VERSION}/Python-$VERSION.tar.xz" \
      && wget --quiet -O python-${VERSION}.tar.xz.sigstore "https://www.python.org/ftp/python/${VERSION}/Python-$VERSION.tar.xz.sigstore" \
      # Verify the Python tarball signature with cosign.
      && cosign verify-blob python-${VERSION}.tar.xz \
        --certificate-oidc-issuer "${ISSUER}" \
        --certificate-identity "${IDENTITY}" \
        --bundle python-${VERSION}.tar.xz.sigstore \
      && mkdir -p /usr/src/python-${VERSION} \
      && tar -xJC /usr/src/python-${VERSION} --strip-components=1 -f python-${VERSION}.tar.xz \
      && rm python-${VERSION}.tar.xz \
      && cd /usr/src/python-${VERSION} \
      && ./configure \
          --enable-shared \
          --with-system-ffi \
      && make -j$(nproc) \
      && make install \
      && ldconfig \
  ; done \
  && rm -rf /usr/src/python* \
  && rm -rf ~/.cache/

# Install pip on Python 3.11
# If the environment variable is called "PIP_VERSION", pip explodes with
# "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION=23.1.2
RUN wget --no-check-certificate -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
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
RUN python3.9 /tmp/get-pip.py
RUN python3.10 /tmp/get-pip.py
RUN python3.12 /tmp/get-pip.py
RUN python3.13 /tmp/get-pip.py
RUN python3.14 /tmp/get-pip.py

RUN rm /tmp/get-pip.py

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
RUN python3.9 -m pip
RUN python3.10 -m pip
RUN python3.11 -m pip
RUN python3.12 -m pip
RUN python3.13 -m pip
RUN python3.14 -m pip

CMD ["python3.11"]
