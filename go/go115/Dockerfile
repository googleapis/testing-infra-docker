# Copyright 2020 Google LLC
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

FROM golang:1.15


# Install dependencies
RUN set -ex; \
  apt-get update -y; \
  apt-get install -y \
    make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
    apt-transport-https ca-certificates curl gnupg-agent lsb-release software-properties-common \
    unzip wget vim; \
    rm -rf /var/lib/apt/lists/*

# Install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Install pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

ENV PATH /root/.pyenv/bin:$PATH
ENV PATH /root/.pyenv/shims:$PATH

RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> .bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> .bashrc && \
    echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

# Install Python 3.7 & 3.8, defaults to 3.8
RUN for PYTHON_VERSION in 3.7.10 3.8.8; do \
    pyenv install ${PYTHON_VERSION} && \
    pyenv global ${PYTHON_VERSION} && \
    python3 -m pip install --upgrade pip setuptools; done

# Install protoc
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip
RUN unzip protoc-3.7.1-linux-x86_64.zip
RUN mv bin/protoc /bin/protoc && which protoc

# Install gcloud SDK
RUN mkdir -p /usr/local/gcloud && \
    curl -sSL https://sdk.cloud.google.com | bash -s -- --install-dir=/usr/local/gcloud

# Install tools used in build
RUN GO111MODULE=on go get honnef.co/go/tools/cmd/staticcheck@latest

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

WORKDIR $GOPATH
