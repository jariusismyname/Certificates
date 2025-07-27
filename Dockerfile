# Dockerfile
FROM php:8.2-apache

# Enable Apache Rewrite Module
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev unzip sqlite3 libsqlite3-dev \
    && docker-php-ext-install pdo pdo_sqlite zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Laravel files
COPY . .

# Set environment
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Update Apache config to serve from public/
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy default env and set Laravel key
# Copy default env and set Laravel key
COPY .env.example .env
RUN sed -i 's|^DB_DATABASE=.*|DB_DATABASE=/var/www/html/database/database.sqlite|' .env

RUN php artisan key:generate

# Create SQLite database file
# Create SQLite file with correct permissions
RUN mkdir -p database && touch database/database.sqlite
RUN chmod -R 775 database
RUN chown -R www-data:www-data database

 

