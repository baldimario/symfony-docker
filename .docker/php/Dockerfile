FROM php:7.2.13-fpm

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    librabbitmq-dev \
    libssh-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    libssl1.0-dev \
    git \
    wget \
    ssh \
    libpcre3-dev \
    --no-install-recommends

RUN docker-php-ext-install zip intl mbstring mysqli pdo_mysql exif xmlrpc \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN pecl install -o -f oauth mongodb amqp \
    && rm -rf /tmp/pear

RUN docker-php-ext-enable mongodb oauth amqp

RUN apt-get purge -y g++ \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/ \
    && rm -rf /tmp/*

# install composer
RUN curl --silent --show-error -o composer-setup.php https://getcomposer.org/installer \
    && EXPECTED_SIGNATURE=$(curl --silent --show-error https://composer.github.io/installer.sig) \
    && ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', '/var/www/html/composer-setup.php');") \
    && if [ "${EXPECTED_SIGNATURE}" != "${ACTUAL_SIGNATURE}" ]; then \
    >&2 echo 'ERROR: Invalid composer installer signature' \
    && rm composer-setup.php \
    && exit 1 \
    ; fi \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php
    
RUN composer self-update --1

RUN composer global require "fxp/composer-asset-plugin:^1.4.0"

RUN usermod -u 1000 www-data

RUN groupadd dev -g 999
RUN useradd dev -g dev -d /home/dev -m

EXPOSE 9000
CMD ["php-fpm"]