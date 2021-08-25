FROM alpine:3.14

LABEL maintainer="selim013@gmail.com"

RUN apk add --no-cache curl \
    imagemagick \
    apache2 \
    php8 \
    php8-apache2 \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-ftp \
    php8-gd \
    php8-iconv \
    php8-json \
    php8-mbstring \
    php8-mysqli \
    php8-opcache \
    php8-openssl \
    php8-pgsql \
    php8-sqlite3 \
    php8-tokenizer \
    php8-xml \
    php8-zlib \
    php8-zip \
    su-exec

### phpBB
ENV PHPBB_VERSION 3.3.4
ENV PHPBB_SHA256 'a2436e375acf9ec8846fda82ffeda51774627967308fb3b71d395b90a1acfe8b'

WORKDIR /tmp

RUN curl -SL https://download.phpbb.com/pub/release/3.3/${PHPBB_VERSION}/phpBB-${PHPBB_VERSION}.tar.bz2 -o phpbb.tar.bz2 \
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