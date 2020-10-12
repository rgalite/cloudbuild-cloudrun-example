# Use the official PHP 7.3 image.
# https://hub.docker.com/_/php
FROM php:7.3-apache

RUN apt-get update -y && apt-get install git zip unzip -y
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN service apache2 restart
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
WORKDIR /var/www/html/
COPY composer.json /var/www/html
RUN composer install

# Copy local code to the container image.
COPY . /var/www/html/

# Use the PORT environment variable in Apache configuration files.
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Configure PHP for development.
# Switch to the production php.ini for production operations.
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# https://hub.docker.com/_/php#configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
