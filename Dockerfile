FROM php:8.1-fpm

# Setting workdir
WORKDIR /var/www

# Install Dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    nginx \
    default-mysql-server \
    default-mysql-client \
    procps \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Installing Redis
RUN apt-get install -y redis-server

# Enable redis ext

RUN pecl install -o -f redis \ 
	&& rm -rf /tmp/pear \
	&& docker-php-ext-enable redis

# PHP Extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Installing basic editors
RUN apt-get install -y \
	vim \
	nano

# Supervisor
RUN apt-get install -y supervisor

# Creating conf directory for supervisor
RUN mkdir -p /etc/supervisor/conf.d

# Network tools
RUN apt-get update && apt-get install -y \
    iputils-ping

# Add dos2unix to convert the .sh files to unix executable because of the Windows-style line endings
RUN apt-get install -y dos2unix


# Custom aliases
RUN echo "alias pu='./vendor/phpunit/phpunit/phpunit'" >> ~/.bashrc \
    && echo "alias puf='./vendor/phpunit/phpunit/phpunit --filter'" >> ~/.bashrc \
    && echo "alias c='clear'" >> ~/.bashrc 

COPY ./init.sh /usr/local/bin/init.sh

# Make init.sh executable
RUN dos2unix /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

#Exposing ports
EXPOSE 80 6379 3306

# Entry proccess point
CMD ["/usr/local/bin/init.sh"]
