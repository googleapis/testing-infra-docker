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

FROM ubuntu:focal

ENTRYPOINT /bin/bash

# Version notes:
# * The gems gem is pinned to 1.2.0 because 1.3.0 requires Ruby 3.1. We can
#   update it to 1.3.0 once we drop Ruby 3.0 support.
# * The bundler gem is pinned to 2.5.23 because 2.6 requires Ruby 3.1. We can
#   update it to 2.6 once we drop Ruby 3.0 support.
ENV RUBY_30_VERSION=3.0.7 \
    RUBY_31_VERSION=3.1.6 \
    RUBY_32_VERSION=3.2.7 \
    RUBY_33_VERSION=3.3.7 \
    RUBY_34_VERSION=3.4.2 \
    BUNDLER_VERSION=2.5.23 \
    RAKE_VERSION=13.2.1 \
    TOYS_VERSION=0.15.6 \
    GEMS_VERSION=1.2.0 \
    JWT_VERSION=2.10.1 \
    PYTHON_VERSION=3.10.16 \
    NODEJS_VERSION=18.20.7 \
    GH_VERSION=2.67.0

ENV OLDEST_RUBY_VERSION=$RUBY_30_VERSION \
    NEWEST_RUBY_VERSION=$RUBY_33_VERSION \
    DEFAULT_RUBY_VERSION=$RUBY_33_VERSION \
    RUBY_VERSIONS="$RUBY_30_VERSION $RUBY_31_VERSION $RUBY_32_VERSION $RUBY_33_VERSION $RUBY_34_VERSION"

# Legacy envs we may be able to get rid of once we verify they're not used.
ENV BUNDLER1_VERSION=1.17.3 \
    BUNDLER2_VERSION=$BUNDLER_VERSION

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
      libasound2 \
      libbz2-dev \
      libffi-dev \
      libgdbm-dev \
      liblzma-dev \
      libmagickwand-dev \
      libmysqlclient-dev \
      libncurses5-dev \
      libpq-dev \
      libreadline-dev \
      libreadline6-dev \
      libsqlite3-dev \
      libssl-dev \
      libvips-dev \
      libyaml-dev \
      make \
      memcached \
      mysql-server \
      pkg-config \
      postgresql \
      postgresql-contrib \
      python-openssl \
      qt5-qmake \
      software-properties-common \
      sqlite3 \
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
RUN for version in ${RUBY_VERSIONS}; do \
      rbenv install "$version" \
        && rbenv global "$version" \
        && gem update --system \
        && gem install bundler:${BUNDLER_VERSION} \
                       rake:${RAKE_VERSION} \
                       toys:${TOYS_VERSION} \
                       gems:${GEMS_VERSION} \
                       jwt:${JWT_VERSION}; \
    done \
    && rbenv global ${DEFAULT_RUBY_VERSION}

# Install pyenv
ENV PYENV_ROOT=/root/.pyenv
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && cd $PYENV_ROOT \
    && src/configure \
    && make -C src
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> .bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> .bashrc
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Install python
RUN pyenv install ${PYTHON_VERSION} \
    && pyenv global ${PYTHON_VERSION}

# Install nodenv
ENV NODENV_ROOT=/root/.nodenv
RUN git clone --depth=1 https://github.com/nodenv/nodenv.git $NODENV_ROOT \
    && cd $NODENV_ROOT \
    && src/configure \
    && make -C src
ENV PATH $NODENV_ROOT/shims:$NODENV_ROOT/bin:$PATH
RUN echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(nodenv init -)"' >> ~/.bashrc
RUN mkdir -p "$(nodenv root)"/plugins \
    && git clone --depth=1 https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build

# Install nodejs
RUN nodenv install ${NODEJS_VERSION} \
    && nodenv global ${NODEJS_VERSION}

# Install phantomjs for ruby-docs-samples
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/ \
    && ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/ \
    && rm phantomjs-2.1.1-linux-x86_64.tar.bz2

# Install latest Chrome for testing
RUN CHROME_URL=$(curl -s https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json | jq -r '.channels.Stable.downloads.chrome[] | select(.platform == "linux64") | .url') \
    && curl -sSLf --retry 3 --output /tmp/chrome-linux64.zip "$CHROME_URL" \
    && apt-get install unzip \
    && unzip /tmp/chrome-linux64.zip -d /opt \
    && ln -s /opt/chrome-linux64/chrome /usr/local/bin/chrome \
    && rm /tmp/chrome-linux64.zip

# Install latest chromedriver
RUN CHROMEDRIVER_URL=$(curl -s https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json | jq -r '.channels.Stable.downloads.chromedriver[] | select(.platform == "linux64") | .url') \
    && curl -sSLf --retry 3 --output /tmp/chromedriver-linux64.zip "$CHROMEDRIVER_URL" \
    && unzip -o /tmp/chromedriver-linux64.zip -d /tmp \
    && rm -rf /tmp/chromedriver-linux64.zip \
    && mv -f /tmp/chromedriver-linux64/chromedriver "/usr/local/bin/chromedriver" \
    && chmod +x "/usr/local/bin/chromedriver"

# Install gh
RUN mkdir -p /opt/local \
    && wget https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz \
    && tar xvzf gh_${GH_VERSION}_linux_amd64.tar.gz -C /opt/local/ \
    && ln -s /opt/local/gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin/ \
    && rm gh_${GH_VERSION}_linux_amd64.tar.gz

# Install gcloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && \
    apt-get install google-cloud-cli -y

# Allow non-root users read access to /root (for Trampoline V2)
RUN chmod -v a+rx /root
