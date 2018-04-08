FROM php:7.2-fpm-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN set -ex \
  	&& apk update \
    && apk add --no-cache git mysql-client curl openssh-client icu libpng libjpeg-turbo \
    && apk add --no-cache --virtual build-dependencies icu-dev libxml2-dev freetype-dev libpng-dev libjpeg-turbo-dev g++ make autoconf \
    && docker-php-source extract \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-source delete \
    && docker-php-ext-install pdo pdo_mysql zip gd \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com \
    && cd  / && rm -fr /src \
    && apk del build-dependencies \
    && rm -rf /tmp/* 

USER www-data

WORKDIR /var/www/html
CMD ["php-fpm"]
