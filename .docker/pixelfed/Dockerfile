FROM php:8.3-fpm
# Install apps/php extensions to base image.
RUN apt-get update && apt-get install -y \
    libfreetype-dev libjpeg62-turbo-dev libpng-dev \
    libicu-dev libzip-dev ffmpeg
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install bcmath exif intl zip
RUN pecl install --onlyreqdeps --force redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis
RUN docker-php-ext-install pdo_mysql mysqli
RUN docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl
RUN apt-get install -y gosu

# Pull Composer from offical image
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# Configure PHP settings
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY ./.docker/pixelfed/pixelfed-settings.ini /usr/local/etc/php/conf.d/pixelfed-settings.ini

# Pull in the Pixelfed source and sort permissions
COPY ./source /src
RUN rm -rf /var/www/html && mv /src /var/www/html && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 644 /var/www/html && \
    find /var/www/html/ -type d -exec chmod 755 {} \;

# Install composer files
WORKDIR /var/www/html
RUN composer install --no-ansi --no-interaction --optimize-autoloader

# Copy our post-start hook and make it executable
COPY ./.docker/pixelfed/post_start.sh /post_start.sh
RUN chmod +x /post_start.sh
