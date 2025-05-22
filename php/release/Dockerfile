# Create a git-base image with the base libgit2-dev dependency
# and git
FROM marketplace.gcr.io/google/debian12:latest AS git-base
RUN apt-get update && \
    apt-get -y install \
            build-essential \
            git \
            libgit2-dev

# build the splitsh go binary (install golang)
FROM git-base AS splitsh
RUN mkdir /workspace
WORKDIR /workspace

# install golang
ENV GO_VERSION=1.19.13
ADD "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" /workspace/
RUN tar -zxf "go${GO_VERSION}.linux-amd64.tar.gz"
ENV PATH="${PATH}:/workspace/go/bin/" \
    GOROOT=/workspace/go

RUN apt-get install -y pkg-config

# compile splitsh go binary
RUN git clone --depth 1 --branch v2.0.0 https://github.com/splitsh/lite.git /workspace/lite && \
        cd /workspace/lite && \
        go build -o /workspace/splitsh-lite github.com/splitsh/lite

# build the php-release image
FROM git-base
ENV PHP_DIR=/opt/php84
ENV PHP_SRC_DIR=/usr/local/src/php84-build
ENV PATH=${PATH}:/usr/local/bin:${PHP_DIR}/bin
ENV PHP_VERISON=8.4.3

RUN apt-get update && \
    apt-get -y install \
            autoconf \
            build-essential \
            curl \
            git-core \
            jq \
            libbz2-dev \
            libcurl4-openssl-dev \
            libc-client2007e \
            libc-client2007e-dev \
            libfcgi-dev \
            libfcgi0ldbl \
            libfreetype6-dev \
            libicu-dev \
            libjpeg-dev \
            libkrb5-dev \
            libmcrypt-dev \
            libmagickwand-dev \
            libpng-dev \
            libpq-dev \
            libsodium-dev \
            libssl-dev \
            libxml2-dev \
            libxslt1-dev \
            libzip-dev \
            unixodbc-dev \
            php-imagick \
            wget \
            zip \
            zlib1g-dev \
            pkg-config \
            sqlite3 \
            libsqlite3-dev \
            libonig-dev \
            uuid-runtime

# Remove old version of PHP
RUN apt purge -y php-common

RUN ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a && \
    mkdir -p ${PHP_DIR} ${PHP_SRC_DIR} ${PHP_DIR}/lib/conf.d && \
    cd ${PHP_SRC_DIR} && \
    wget http://us1.php.net/get/php-$PHP_VERISON.tar.bz2/from/this/mirror \
         -O php-$PHP_VERISON.tar.bz2 && \
    tar jxf php-$PHP_VERISON.tar.bz2 && \
    cd php-$PHP_VERISON && \
    ./configure \
        --prefix=${PHP_DIR} \
        --with-config-file-scan-dir=${PHP_DIR}/lib/conf.d \
        --with-pdo-pgsql \
        --with-zlib-dir \
        --enable-mbstring \
        --enable-soap \
        --enable-intl \
        --enable-calendar \
        --with-curl \
        --with-zlib \
        --with-pgsql \
        --disable-rpath \
        --with-bz2 \
        --with-zlib \
        --enable-sockets \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-sysvmsg \
        --enable-pcntl \
        --enable-mbregex \
        --enable-exif \
        --enable-bcmath \
        --enable-dom \
        --with-mhash \
        --with-pdo-mysql \
        --with-sodium=shared \
        --with-mysqli \
        --with-openssl \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        --with-libdir=/lib/x86_64-linux-gnu \
        --enable-ftp \
        --with-imap \
        --with-imap-ssl \
        --with-gettext \
        --with-xsl \
        --with-zip \
        --with-kerberos \
        --enable-fpm \
        --with-pear && \
        make && \
        make install && \
        pecl install grpc pdo_sqlsrv && \
        cp php.ini-production ${PHP_DIR}/lib/php.ini && \
        echo 'zend_extension=opcache.so' >> ${PHP_DIR}/lib/php.ini && \
        echo 'extension=sodium' >> ${PHP_DIR}/lib/php.ini && \
        echo 'extension=grpc.so' >> ${PHP_DIR}/lib/conf.d/ext-grpc.ini && \
        git clone https://github.com/Imagick/imagick /tmp/imagick && cd /tmp/imagick && phpize && ./configure && make && make install && cd - && \
        echo 'extension=imagick.so' >> ${PHP_DIR}/lib/conf.d/ext-imagick.ini && \
        echo 'extension=pdo_sqlsrv.so' >> ${PHP_DIR}/lib/conf.d/ext-pdo_sqlsrv.ini && \
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        php -r "if (hash_file('SHA384', 'composer-setup.php') === rtrim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
        php composer-setup.php --filename=composer --install-dir=/usr/local/bin

# Install Google Cloud SDK
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
        -o ${HOME}/google-cloud-sdk.tar.gz \
    && tar xzf ${HOME}/google-cloud-sdk.tar.gz -C $HOME \
    && ${HOME}/google-cloud-sdk/install.sh \
        --usage-reporting false \
        --path-update false \
        --command-completion false

# Make composer and gcloud bins available via the PATH variable
ENV PATH="$PATH:/root/.config/composer/vendor/bin:/root/google-cloud-sdk/bin"

# Configure Google Cloud SDK
RUN gcloud config set app/promote_by_default false && \
    gcloud config set disable_prompts true && \
    gcloud -q components install app-engine-python && \
    gcloud -q components update

# Install phpunit and php-cs-fixer globally
RUN composer global require \
    phpunit/phpunit:^8.0 \
    friendsofphp/php-cs-fixer

# Install Python3
RUN wget https://www.python.org/ftp/python/3.9.14/Python-3.9.14.tgz \
    && tar -xvf Python-3.9.14.tgz \
    && ./Python-3.9.14/configure --enable-optimizations \
    && make altinstall

# Install pip
RUN wget -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
  && python3.9 /tmp/get-pip.py \
  && rm /tmp/get-pip.py \
  && python3.9 -m pip

# add the splitsh-lite command
COPY --from=splitsh /workspace/splitsh-lite /bin/splitsh-lite
