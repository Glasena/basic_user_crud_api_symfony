FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    git \
    unzip \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add a new user and switch to it
RUN useradd -ms /bin/bash symfony
USER symfony
WORKDIR /home/symfony

# Copy existing application directory contents
COPY --chown=symfony:symfony . /home/symfony

# Install Symfony and project dependencies
RUN composer install

# Switch back to root to set appropriate permissions
USER root
RUN chown -R www-data:www-data /home/symfony

# Expose port 8000 and start Symfony server
EXPOSE 8000
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
