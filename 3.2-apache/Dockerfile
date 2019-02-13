FROM alpine:3.9

MAINTAINER Dmitry Seleznyov <selim013@gmail.com>

RUN apk add --no-cache curl \
    imagemagick \
    apache2 \
    php7 \
    php7-apache2 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-ftp \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mysqli \
    php7-opcache \
    php7-openssl \
    php7-pgsql \
    php7-sqlite3 \
    php7-tokenizer \
    php7-xml \
    php7-zlib \
    php7-zip \
    su-exec

### phpBB
ENV PHPBB_VERSION 3.2.5
ENV PHPBB_SHA256 '4c50f8657a6f19e73468bac563c1804e112c54c1f700d24803cacc22d080d08b'

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
RUN mkdir -p /run/apache2 /phpbb/opcache \
    && chown apache:apache /run/apache2 /phpbb/opcache

COPY apache2/httpd.conf /etc/apache2/
COPY apache2/conf.d/* /etc/apache2/conf.d/

COPY php/php.ini /etc/php7/
COPY php/php-cli.ini /etc/php7/
COPY php/conf.d/* /etc/php7/conf.d/

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