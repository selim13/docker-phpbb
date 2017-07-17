FROM alpine:3.6

MAINTAINER Dmitry Seleznyov <selim013@gmail.com>

RUN apk add --no-cache curl \
  imagemagick \
  apache2 \
  php5-apache2 \
  php5-cli \
  php5-ctype \
  php5-opcache \
  php5-curl \
  php5-dom \
  php5-openssl \
  php5-ftp \
  php5-mysqli \
  php5-sqlite3 \
  php5-pgsql \
  php5-json \
  php5-xml \
  php5-zlib \
  php5-zip \
  php5-gd \
  su-exec

### phpBB
ENV PHPBB_VERSION 3.2.1
ENV PHPBB_SHA256 'ea1c7e08aa3466aa325deca5d8998a24d103bfecf23826ce61fe5390b6a09f71'

WORKDIR /tmp

RUN curl -SL https://www.phpbb.com/files/release/phpBB-${PHPBB_VERSION}.tar.bz2 -o phpbb.tar.bz2 \
    && echo "${PHPBB_SHA256}  phpbb.tar.bz2" | sha256sum -c - \
    && tar -xjf phpbb.tar.bz2 \
    && mkdir /phpbb \
    && mkdir /phpbb/sqlite \
    && mv phpBB3 /phpbb/www \
    && rm -f phpbb.tar.bz2

COPY phpbb/config.php /phpbb/www

### Server
RUN mkdir -p /run/apache2 \
    && chown apache:apache /run/apache2

COPY apache2/httpd.conf /etc/apache2/
COPY apache2/conf.d/* /etc/apache2/conf.d/

COPY php5/php.ini /etc/php5/
COPY php5/php-cli.ini /etc/php5/
COPY php5/conf.d/* /etc/php5/conf.d/
# Alpine 3.6 doesn't create this symlink for PHP5 in favour of PHP7
RUN ln -s /usr/bin/php5 /usr/bin/php

COPY start.sh /usr/local/bin/

RUN chown -R apache:apache /phpbb
WORKDIR /phpbb/www

#VOLUME /phpbb/sqlite
#VOLUME /phpbb/www/files
#VOLUME /phpbb/www/store
#VOLUME /phpbb/www/images/avatars/upload

ENV PHPBB_INSTALL= \
    PHPBB_DB_DRIVER=sqlite3 \
    PHPBB_DB_HOST=/phpbb/sqlite/sqlite.db \
    PHPBB_DB_PORT= \
    PHPBB_DB_NAME= \
    PHPBB_DB_USER= \
    PHPBB_DB_PASSWD= \
    PHPBB_DB_TABLE_PREFIX=phpbb_ \
    PHPBB_DB_AUTOMIGRATE= \
    PHPBB_DISPLAY_LOAD_TIME= \
    PHPBB_DEBUG= \
    PHPBB_DEBUG_CONTAINER=

EXPOSE 80
CMD ["start.sh"]