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

ENV RUBY_27_VERSION=2.7.8 \
    RUBY_30_VERSION=3.0.7 \
    RUBY_31_VERSION=3.1.6 \
    RUBY_32_VERSION=3.2.6 \
    RUBY_33_VERSION=3.3.6 \
    BUNDLER1_VERSION=1.17.3 \
    BUNDLER2_VERSION=2.4.22 \
    RAKE_VERSION=13.2.1 \
    TOYS_VERSION=0.15.6 \
    PYTHON_VERSION=3.10.15 \
    NODEJS_VERSION=18.20.5 \
    DOCUPLOADER_VERSION=0.6.5

ENV OLDEST_RUBY_VERSION=$RUBY_30_VERSION \
    NEWEST_RUBY_VERSION=$RUBY_33_VERSION \
    DEFAULT_RUBY_VERSION=$RUBY_33_VERSION \
    RUBY_VERSIONS="$RUBY_27_VERSION $RUBY_30_VERSION $RUBY_31_VERSION $RUBY_32_VERSION $RUBY_33_VERSION"

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
        && gem install bundler:${BUNDLER2_VERSION} rake:${RAKE_VERSION} toys:${TOYS_VERSION}; \
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
    && pyenv global ${PYTHON_VERSION} \
    && python3 -m pip install gcp-docuploader==${DOCUPLOADER_VERSION}

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

# Allow non-root users read access to /root (for Trampoline V2)
RUN chmod -v a+rx /root
