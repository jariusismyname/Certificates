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

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Set environment
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Update Apache config
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Generate APP_KEY
RUN php artisan key:generate

# Create SQLite file
RUN mkdir -p database && touch database/database.sqlite

# Link storage
RUN php artisan storage:link
