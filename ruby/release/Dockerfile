# Copyright 2025 Google LLC
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

FROM ubuntu:focal

ENTRYPOINT /bin/bash

ENV RUBY_VERSION=3.3.7 \
    BUNDLER_VERSION=2.6.5 \
    RAKE_VERSION=13.2.1 \
    TOYS_VERSION=0.15.6 \
    GEMS_VERSION=1.3.0 \
    JWT_VERSION=2.10.1 \
    GH_VERSION=2.67.0 \
    SYFT_VERSION=1.19.0

ENV DEBIAN_FRONTEND noninteractive

# Set the locale
RUN apt-get update \
    && apt-get install -y --no-install-recommends locales \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      apt-transport-https \
      autoconf \
      bison \
      build-essential \
      ca-certificates \
      curl \
      freetds-bin \
      freetds-dev \
      git \
      gpg-agent \
      libasound2 \
      libbz2-dev \
      libffi-dev \
      libgdbm-dev \
      liblzma-dev \
      libncurses5-dev \
      libreadline-dev \
      libreadline6-dev \
      libssl-dev \
      libvips-dev \
      libyaml-dev \
      make \
      memcached \
      pkg-config \
      qt5-qmake \
      software-properties-common \
      wget \
      xz-utils \
      zlib1g-dev \
      jq \
      libatk-bridge2.0-0 \
      libdrm-dev \
      libgbm-dev \
      libxkbcommon-dev \
    && apt-get -y autoremove \
    && apt-get -y autoclean

# Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce \
    && apt-get -y autoremove \
    && apt-get -y autoclean

# Install rbenv
ENV RBENV_ROOT=/root/.rbenv
RUN git clone --depth=1 https://github.com/rbenv/rbenv.git $RBENV_ROOT \
    && cd $RBENV_ROOT \
    && src/configure \
    && make -C src
ENV PATH $RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN mkdir -p "$(rbenv root)"/plugins \
    && git clone --depth=1 https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# Install ruby
ENV RUBY_CONFIGURE_OPTS --disable-install-doc
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN rbenv install "${RUBY_VERSION}" \
    && rbenv global "${RUBY_VERSION}" \
    && gem update --system \
    && gem install bundler:${BUNDLER_VERSION} \
                   rake:${RAKE_VERSION} \
                   toys:${TOYS_VERSION} \
                   gems:${GEMS_VERSION} \
                   jwt:${JWT_VERSION}

# Install gh
RUN mkdir -p /opt/local \
    && wget https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz \
    && tar xvzf gh_${GH_VERSION}_linux_amd64.tar.gz -C /opt/local/ \
    && ln -s /opt/local/gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin/ \
    && rm gh_${GH_VERSION}_linux_amd64.tar.gz

# Install syft
ADD https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_amd64.deb /workspace/syft.deb
RUN dpkg -i /workspace/syft.deb

# Install gcloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && \
    apt-get install google-cloud-cli -y

# Allow non-root users read access to /root (for Trampoline V2)
RUN chmod -v a+rx /root
