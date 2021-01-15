FROM php:7.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    mariadb-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    supervisor

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Install xDebug
RUN pecl install -f xdebug \
    &&  echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini; \
    printf "xdebug.mode=debug \n\
    xdebug.client_host=localhost \n\
    xdebug.client_port=9005 \n\
    xdebug.discover_client_host=1 \n\
    xdebug.collect_return=1 \n\
    xdebug.collect_params=1" >> /usr/local/etc/php/conf.d/xdebug.ini;

#Install Node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN rm -Rf /var/www/html

RUN chown -R www-data:www-data /var/www/

WORKDIR /var/www/

# Expose port 9000 and start php-fpm server
EXPOSE 9000
