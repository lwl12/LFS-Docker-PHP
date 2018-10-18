FROM php:7-fpm-alpine

# Change Timezone && Install Base Components
RUN apk add --no-cache --virtual .build-deps \
       autoconf \
       g++ \
       libtool \
       make \
       pcre-dev \
    && apk add --no-cache\
       libpq-dev \
       libfreetype6-dev \
       libjpeg62-turbo-dev \
       libpng-dev \
       libmcrypt-dev \
       libmhash-dev \
       ntpdate \
       unzip \
       imagemagick-dev \
       git \
       libintl \
       icu \
       icu-dev \
       libxml2-dev \
       freetype-dev \
       libjpeg-turbo-dev \
       libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install gd pdo_mysql mysqli pgsql pdo_pgsql opcache zip xmlrpc exif bcmath intl zip soap iconv gettext\
    && pecl install redis \
    && pecl install imagick \
	&& docker-php-ext-enable redis imagick \
    && apk del .build-deps \


# PHP Composer
ADD https://dl.laravel-china.org/composer.phar /usr/local/bin/composer
RUN chmod a+x /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://packagist.laravel-china.org 

CMD ["php-fpm"]