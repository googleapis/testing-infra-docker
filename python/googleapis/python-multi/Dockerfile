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
    aspell \
    aspell-en \
    build-essential \
    ca-certificates \
    dictionaries-common \
    curl \
    dirmngr \
    enchant-2 \
    gdal-bin \
    git \
    gpg-agent \
    graphviz \
    hunspell-en-us \
    jq \
    libbz2-dev \
    libdb5.3-dev \
    libenchant-2-2 \
    libexpat1-dev \
    libffi-dev \
    libgdal-dev \
    liblzma-dev \
    libpq-dev \
    libreadline-dev \
    libsnappy-dev \
    libssl-dev \
    libsqlite3-dev \
    memcached \
    portaudio19-dev \
    redis-server \
    software-properties-common \
    ssh \
    sudo \
    tcl \
    tcl-dev \
    tk \
    tk-dev \
    unzip \
    uuid-dev \
    uuid-runtime \
    vim \
    wget \
    zip \
    zlib1g-dev \
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

# Install Microsoft ODBC 17 Driver and unixodbc for testing SQL Server samples
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update \
  && ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    msodbcsql17 \
    unixodbc-dev \
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

# TODO: Remove this code once the next patch version of Python 3.12 runtime is released
# In the interim, remove bundled setuptools 67.6.1 wheel
# since it does not include a fix for CVE-2025-47273/CVE-2025-47273.
# As per https://github.com/python/cpython/issues/135374#issuecomment-2963361124,
# this test file is not needed at runtime.
RUN rm -rf /usr/local/lib/python3.12/test/wheeldata/setuptools-67.6.1-py3-none-any.whl

# TODO: Remove this code once support for Python3.9/Python3.10 is dropped
# There is no patch for CVE-2023-5752. We need to manually remove the vulnerable pip-23.0.1 binary
# See upstream bug https://github.com/python/cpython/issues/131860
RUN rm -rf /usr/local/lib/python3.9/ensurepip/_bundled/pip-23.0.1-py3-none-any.whl
RUN rm -rf /usr/local/lib/python3.10/ensurepip/_bundled/pip-23.0.1-py3-none-any.whl

# Install pip on Python 3.10 only.
# If the environment variable is called "PIP_VERSION", pip explodes with
# "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION=26.0
RUN wget --no-check-certificate -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
    && python3.10 /tmp/get-pip.py "pip==$PYTHON_PIP_VERSION" \
    # we use "--force-reinstall" for the case where the version of pip we're trying to install is the same as the version bundled with Python
    # ("Requirement already up-to-date: pip==8.1.2 in /usr/local/lib/python3.6/site-packages")
    # https://github.com/docker-library/python/pull/143#issuecomment-241032683
    && pip3 install --no-cache-dir --upgrade --force-reinstall "pip==$PYTHON_PIP_VERSION" \
    # then we use "pip list" to ensure we don't have more than one pip version installed
    # https://github.com/docker-library/python/pull/100
    && [ "$(pip list |tac|tac| awk -F '[ ()]+' '$1 == "pip" { print $2; exit }')" = "$PYTHON_PIP_VERSION" ]

# Ensure Pip for all python3 versions
RUN python3.9 /tmp/get-pip.py
RUN python3.11 /tmp/get-pip.py
RUN python3.12 /tmp/get-pip.py
RUN python3.13 /tmp/get-pip.py
RUN python3.14 /tmp/get-pip.py

RUN rm /tmp/get-pip.py

# Test Pip
RUN python3 -m pip
RUN python3.9 -m pip
RUN python3.10 -m pip
RUN python3.11 -m pip
RUN python3.12 -m pip
RUN python3.13 -m pip
RUN python3.14 -m pip

# Install nox and upgrade setuptools installations for Python 3.9, 3.10 and 3.11
# for CVE-2025-47273/CVE-2025-47273.
# See https://github.com/python/cpython/issues/135374#issuecomment-2963361124
COPY requirements.txt /requirements.txt

RUN for PYTHON_VERSION in 3.9 3.10 3.11; do \
    /usr/local/bin/python${PYTHON_VERSION} -m pip \
    install \
    --no-cache-dir \
    --require-hashes \
    -r /requirements.txt \
    # Remove bundled setuptools 75.3.2 wheel
    # since it does not include a fix for CVE-2025-47273/CVE-2025-47273.
    && rm -rf /usr/local/lib/python${PYTHON_VERSION}/site-packages/virtualenv/seed/wheels/embed/setuptools-75.3.2-py3-none-any.whl \
  ; done

# Python 3.12 is preferred because it does not include
# a bundled version of setuptools in `Lib/ensurepip/_bundled`
# which could be impacted by CVE-2025-47273/CVE-2025-47273.
RUN python3.12 -m venv /venv
RUN /venv/bin/python -m pip install --no-cache-dir -r /requirements.txt
ENV PATH=/venv/bin:$PATH

# TODO: Remove this code once there is a newer version of virtualenv which does not include setuptools 75.3.2
# https://github.com/pypa/virtualenv/tree/main/src/virtualenv/seed/wheels/embed
# In the interim, remove the bundled setuptools 75.3.2 wheel
# since it does not include a fix for CVE-2025-47273/CVE-2025-47273.
RUN rm -rf /venv/lib/python3.12/site-packages/virtualenv/seed/wheels/embed/setuptools-75.3.2-py3-none-any.whl

# Setup Cloud SDK
ENV CLOUD_SDK_VERSION=555.0.0
# Use python 3.12 for cloud sdk.
ENV CLOUDSDK_PYTHON=python3.12
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN tar xzf google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN /google-cloud-sdk/install.sh
ENV PATH=/google-cloud-sdk/bin:$PATH

# Enable redis-server on boot.
RUN redis-server /etc/redis/redis.conf
