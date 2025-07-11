FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
git unzip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libzip-dev zip curl

RUN apt-get update && apt-get install -y \
git unzip curl nodejs npm

# Install Node.js 20 (replace apt's outdated version)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

WORKDIR /var/www/html

COPY . .

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer install
RUN npm install && npm run build

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 1005

CMD ["php-fpm"]