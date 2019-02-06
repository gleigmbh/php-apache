FROM php:7.2-apache
WORKDIR /var/www/html
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get update -y && apt-get install -y mc openssl zip unzip git && rm -r /var/lib/apt/lists/* \
    && composer global require hirak/prestissimo barryvdh/composer-cleanup-plugin \
    && mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install pdo mbstring pdo_mysql opcache -j$(nproc) \
    && usermod -u 1000 www-data && groupmod -g 1000 www-data \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /root/.composer/cache/* \
    && a2enmod rewrite
EXPOSE 8181
