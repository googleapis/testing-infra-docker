FROM gcr.io/gcp-runtimes/ubuntu_18_0_4

ENV PHPBREW_ROOT /root/.phpbrew
ENV PHPBREW_HOME /root/.phpbrew
ENV PHPBREW_SET_PROMPT 1

# ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
  && apt-get -qqy install git \
  && apt-get -qqy install wget \
  && apt-get -qqy install curl \
  && apt-get -qqy install ant ant-contrib sqlite3 \
  && apt-get -qqy install \
      autoconf \
      build-essential \
      libbz2-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      libxslt1-dev \
      libonig-dev \
      php7.2-cli \
      php7.2-bz2 \
      pkg-config \
      libcurl4-gnutls-dev \
      libzip-dev zip \
      libmagickwand-dev \
      php-imagick \
      jq \
  && apt-get clean -y \
  && apt-get autoclean -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && rm -rf /var/lib/apt/lists/*

# Use a better shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install and initialize PHPBrew
RUN mkdir -p /usr/bin/ \
    && wget -q -O /usr/bin/phpbrew https://github.com/phpbrew/phpbrew/raw/master/phpbrew \
    && chmod +x /usr/bin/phpbrew \
    && phpbrew init \
    && echo 'source $HOME/.phpbrew/bashrc' >> /root/.bashrc

# Install PHP 8.0
RUN phpbrew install "8.0" \
    +default +bcmath +bz2 +calendar +cli +ctype +dom +fileinfo +filter +json \
    +mbregex +mbstring +mhash +pcntl +pcre +pdo +phar +posix +readline +sockets \
    +tokenizer +xml +curl +zip +openssl=yes +opcache +fpm +sqlite +mysql \
    +default +intl +gettext

# Install PHP 8.1
RUN phpbrew install "8.1" \
    +default +bcmath +bz2 +calendar +cli +ctype +dom +fileinfo +filter +json \
    +mbregex +mbstring +mhash +pcntl +pcre +pdo +phar +posix +readline +sockets \
    +tokenizer +xml +curl +zip +openssl=yes +opcache +fpm +sqlite +mysql \
    +default +intl +gettext

# Install PHP 8.2
RUN phpbrew install "8.2" \
    +default +bcmath +bz2 +calendar +cli +ctype +dom +fileinfo +filter +json \
    +mbregex +mbstring +mhash +pcntl +pcre +pdo +phar +posix +readline +sockets \
    +tokenizer +xml +curl +zip +openssl=yes +opcache +fpm +sqlite +mysql \
    +default +intl +gettext

# Install and enable Imagemagick extension for PHP 8.0, 8.1, and 8.2
RUN source ~/.phpbrew/bashrc \
    && phpbrew switch $(phpbrew list | grep 8.0) && phpbrew ext install imagick \
    && phpbrew switch $(phpbrew list | grep 8.1) && phpbrew ext install imagick \
    # On PHP 8.2, Imagemagick must be compiled from src because it is not yet
    # available via PECL
    && phpbrew switch $(phpbrew list | grep 8.2) \
        && git clone https://github.com/Imagick/imagick /tmp/imagick \
        && cd /tmp/imagick \
        && phpize \
        && ./configure \
        && make \
        && make install \
        && phpbrew ext enable imagick

# Install and enable gRPC/memcache/opcache extensions for PHP 8.0, 8.1, and 8.2
RUN source ~/.phpbrew/bashrc \
    && phpbrew each phpbrew ext install grpc \
    && phpbrew each phpbrew ext install memcache \
    && phpbrew each phpbrew ext enable opcache

# Install composer
RUN wget -q -O /usr/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/bin/composer

# Install Google Cloud SDK
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
        -o ${HOME}/google-cloud-sdk.tar.gz \
    && tar xzf ${HOME}/google-cloud-sdk.tar.gz -C $HOME \
    && ${HOME}/google-cloud-sdk/install.sh \
        --usage-reporting false \
        --path-update false \
        --command-completion false \
    && source ${HOME}/google-cloud-sdk/path.bash.inc

# Install Cloud SQL proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
    && chmod +x cloud_sql_proxy \
    && mv cloud_sql_proxy /usr/local/bin

# Make composer and gcloud bins available via the PATH variable
ENV PATH="$PATH:/root/.config/composer/vendor/bin:/root/google-cloud-sdk/bin"

# Configure Google Cloud SDK
RUN gcloud config set app/promote_by_default false && \
    gcloud config set disable_prompts true && \
    gcloud -q components install app-engine-python && \
    gcloud -q components update

# Install php-cs-fixer
RUN composer global require friendsofphp/php-cs-fixer
