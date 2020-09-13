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

FROM ubuntu:bionic

ENTRYPOINT /bin/bash

ENV RUBY_VERSIONS="2.4.10 2.5.8 2.6.6 2.7.1" \
    DEFAULT_RUBY_VERSION=2.6.6 \
    BUNDLER1_VERSION=1.17.3 \
    BUNDLER2_VERSION=2.1.4 \
    PYTHON_VERSION=3.8.5 \
    NODEJS_VERSION=12.18.3

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
      imagemagick \
      libbz2-dev \
      libffi-dev \
      libgdbm5 \
      libgdbm-dev \
      liblzma-dev \
      libmagickwand-dev \
      libncurses5-dev \
      libreadline-dev \
      libreadline6-dev \
      libsqlite3-dev \
      libssl1.0-dev \
      libyaml-dev \
      make \
      pkg-config \
      python-openssl \
      software-properties-common \
      sqlite3 \
      wget \
      xz-utils \
      zlib1g-dev \
    && apt-get -y autoremove \
    && apt-get -y autoclean

# Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce \
    && apt-get -y autoremove \
    && apt-get -y autoclean

# Install rbenv
RUN git clone --depth=1 https://github.com/rbenv/rbenv.git /root/.rbenv \
    && cd /root/.rbenv \
    && src/configure \
    && make -C src
ENV PATH /root/.rbenv/shims:/root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN mkdir -p "$(rbenv root)"/plugins \
    && git clone --depth=1 https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# Install ruby
ENV RUBY_CONFIGURE_OPTS --disable-install-doc
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN for version in ${RUBY_VERSIONS}; do \
      rbenv install "$version" \
        && rbenv global "$version" \
        && gem update --system \
        && gem install bundler:${BUNDLER1_VERSION} bundler:${BUNDLER2_VERSION} rake; \
    done \
    && rbenv global ${DEFAULT_RUBY_VERSION}

# Install pyenv
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git ~/.pyenv \
    && cd /root/.pyenv \
    && src/configure \
    && make -C src
ENV PATH /root/.pyenv/shims:/root/.pyenv/bin:$PATH
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> .bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> .bashrc
RUN echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

# Install python
RUN pyenv install ${PYTHON_VERSION} \
    && pyenv global ${PYTHON_VERSION} \
    && ln -s $(which python) /bin/python3

# Install nodenv
RUN git clone --depth=1 https://github.com/nodenv/nodenv.git ~/.nodenv \
    && cd /root/.nodenv \
    && src/configure \
    && make -C src
ENV PATH /root/.nodenv/shims:/root/.nodenv/bin:$PATH
RUN echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(nodenv init -)"' >> ~/.bashrc
RUN mkdir -p "$(nodenv root)"/plugins \
    && git clone --depth=1 https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build

# Install nodejs
RUN nodenv install ${NODEJS_VERSION} \
    && nodenv global ${NODEJS_VERSION}
