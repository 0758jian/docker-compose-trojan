FROM php:7.3.12-fpm-alpine

MAINTAINER 0758jian <85171648@qq.com>

RUN  apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl-dev \
        imagemagick-dev \
        libtool \
        libxml2-dev \
        tzdata \
        ffmpeg \
        util-linux \
     && apk add --no-cache \
        zip \
        libzip-dev \
        curl \
        git \
        imagemagick \
        freetype \
        supervisor \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        && docker-php-ext-configure gd \
       --with-gd \
       --with-freetype-dir=/usr/include/ \
       --with-png-dir=/usr/include/ \
       --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure zip --with-libzip \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pecl install -o -f redis \
    && docker-php-ext-install \
        curl \
        iconv \
        mbstring \
        gd \
        pdo \
        pdo_mysql \
        xml \
        zip \
        bcmath \
        opcache \
        mysqli \
    && docker-php-ext-enable redis \
    && curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
    && apk del -f .build-deps \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps

WORKDIR /var/www/html
