FROM gcr.io/gcp-runtimes/ubuntu_20_0_4
ENV PHP_DIR=/opt/php82
ENV PHP_SRC_DIR=/usr/local/src/php82-build
ENV PATH=${PATH}:/usr/local/bin:${PHP_DIR}/bin
ENV PHP_VERISON=8.2.6

RUN apt-get update && \
    apt-get -y install \
            autoconf \
            build-essential \
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
            libssl-dev \
            libxml2-dev \
            libxslt1-dev \
            libzip-dev \
            unixodbc-dev \
            php-imagick \
            python-ipaddress \
            wget \
            zip \
            zlib1g-dev \
            pkg-config \
            sqlite3 \
            libsqlite3-dev \
            libonig-dev

# Remove old version of PHP
RUN apt purge -y php7.4-common

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
        --enable-inline-optimization \
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
        --with-mhash \
        --with-pdo-mysql \
        --with-mysqli \
        --with-openssl \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        --with-libdir=/lib/x86_64-linux-gnu \
        --enable-ftp \
        --with-imap \
        --with-imap-ssl \
        --with-gettext \
        --with-xmlrpc \
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
        echo 'extension=grpc.so' >> ${PHP_DIR}/lib/conf.d/ext-grpc.ini && \
        git clone https://github.com/Imagick/imagick /tmp/imagick && cd /tmp/imagick && phpize && ./configure && make && make install && cd - && \
        echo 'extension=imagick.so' >> ${PHP_DIR}/lib/conf.d/ext-imagick.ini && \
        echo 'extension=pdo_sqlsrv.so' >> ${PHP_DIR}/lib/conf.d/ext-pdo_sqlsrv.ini && \
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        php -r "if (hash_file('SHA384', 'composer-setup.php') === rtrim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
        php composer-setup.php --filename=composer --install-dir=/usr/local/bin

# Install phpunit globally
RUN composer global require phpunit/phpunit:^8.0

# Install Google Cloud SDK
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
        -o ${HOME}/google-cloud-sdk.tar.gz \
    && tar xzf ${HOME}/google-cloud-sdk.tar.gz -C $HOME \
    && ${HOME}/google-cloud-sdk/install.sh \
        --usage-reporting false \
        --path-update false \
        --command-completion false

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

# Build php-cs-fixer
RUN composer global require friendsofphp/php-cs-fixer
