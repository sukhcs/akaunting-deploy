FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

RUN \
 echo "**** install build packages ****" && \
 apt update && \
 apt install -y software-properties-common && \
 apt update && \
 add-apt-repository ppa:ondrej/php && \
 apt update && \
 apt install -y \
    apache2 \
    php8.1 \
    libapache2-mod-php8.1 \
    php8.1-common \
    php8.1-imap \
    php8.1-mbstring \
    php8.1-xmlrpc \
    php8.1-soap \
    php8.1-gd \
    php8.1-xml \
    php8.1-intl \
    php8.1-mysql \
    php8.1-cli \
    php8.1-ldap \
    php8.1-zip \
    php8.1-curl \
    php8.1-bcmath \
    unzip \
    curl \
    certbot \
    python-certbot-apache \
    net-tools \
    vim

COPY php.ini /etc/php/8.1/apache2/php.ini

RUN \
 echo "**** install akaunting ****" && \
 curl -O -J -L https://akaunting.com/download.php?version=latest && \
 mkdir -p /var/www/html/akaunting && \
 unzip Akaunting_*.zip -d /var/www/html/akaunting/ && \
 chown -R www-data:www-data /var/www/html/akaunting/ && \
 chmod -R 755 /var/www/html/akaunting/

COPY akaunting.conf /etc/apache2/sites-available/akaunting.conf

RUN \
 a2ensite akaunting && \
 a2enmod rewrite && \
 a2enmod ssl

EXPOSE 80 443

ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2

CMD ["apachectl", "-D",  "FOREGROUND"]
