FROM php:7.1-fpm
RUN apt-get update -y

# Extension
# Curl
RUN apt-get install -y libcurl3-dev && docker-php-ext-install curl
# Mysql & Mysqli
RUN docker-php-ext-install mysqli pdo pdo_mysql
# ImageMagic
RUN apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick
# GD
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
# JSON
RUN apt-get install libxml2-dev -y
RUN docker-php-ext-install json soap
# ZIP
RUN apt-get install -y zlib1g-dev && docker-php-ext-configure zip --with-zlib-dir=/usr && docker-php-ext-install zip
# Other magento requirements
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install ctype
RUN docker-php-ext-install dom
RUN docker-php-ext-install intl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install hash
RUN docker-php-ext-install iconv

RUN apt-get install libmcrypt-dev -y
RUN docker-php-ext-install mcrypt
RUN apt-get install openssl -y

RUN apt-get install libxslt-dev -y
RUN docker-php-ext-install xsl

#composer
RUN apt-get install -y unzip
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#Mailhog
RUN apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git &&\
    rm -rf /var/lib/apt/lists/*
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
#ENV PATH /usr/local/go/bin:$PATH
RUN /usr/local/go/bin/go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail

# Remove apt lists to reduce image size
RUN rm -rf /var/lib/apt/lists/*
# Optional: error log file for php.
RUN mkdir -p /var/log/fpm/ && touch /var/log/fpm/error.log && chmod 777 /var/log/fpm/error.log
