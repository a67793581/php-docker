ARG PHP_VERSION="php:7.0.19-fpm-alpine"
FROM ${PHP_VERSION}
MAINTAINER carlo 28447402@qq.com
ARG TZ="Asia/Shanghai"
ARG CONTAINER_PACKAGE_URL="mirrors.aliyun.com"

#修改软件源
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/community' >> /etc/apk/repositories
RUN apk update
# Fix: https://github.com/docker-library/php/issues/240
RUN apk add gnu-libiconv libstdc++ --no-cache --repository http://${CONTAINER_PACKAGE_URL}/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
#设置时区
RUN apk add --no-cache tzdata && cp "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone
# 安装composer
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar && chmod +x /usr/bin/composer
ENV COMPOSER_HOME=/tmp/composer
# www-data用户uid和gid为82，将其更改为1000（主用户）
RUN apk add --no-cache shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data
#安装 ssh软件
RUN apk add  --no-cache openssh-client >/dev/null
#安装 扩展依赖
RUN apk add --no-cache 'tidyhtml-dev==5.2.0-r1' >/dev/null && ln -s /usr/include/tidybuffio.h /usr/include/buffio.h
RUN apk add  --no-cache bzip2-dev >/dev/null
RUN apk add  --no-cache enchant-dev >/dev/null
RUN apk add  --no-cache  libpng-dev >/dev/null
RUN apk add  --no-cache  gettext-dev >/dev/null
RUN apk add  --no-cache  gmp-dev >/dev/null
RUN apk add  --no-cache  libmcrypt-dev >/dev/null
RUN apk add --no-cache postgresql-dev >/dev/null
RUN apk add --no-cache recode-dev >/dev/null
RUN apk add --no-cache libxml2-dev >/dev/null
RUN apk add --no-cache libxslt-dev >/dev/null
RUN apk add --no-cache gcc >/dev/null
RUN apk add --no-cache g++ >/dev/null
RUN apk add --no-cache autoconf >/dev/null
RUN apk add --no-cache make >/dev/null
#RUN apk add --no-cache php7-dev
##安装 扩展
RUN pecl install mongodb-1.6.1 >/dev/null && docker-php-ext-enable mongodb
RUN pecl install redis-3.1.6 >/dev/null && docker-php-ext-enable redis
RUN pecl install swoole-4.3.6 >/dev/null && docker-php-ext-enable swoole
RUN pecl install apcu-5.1.7 >/dev/null && docker-php-ext-enable apcu

RUN docker-php-ext-install exif >/dev/null
RUN docker-php-ext-install mbstring >/dev/null
RUN docker-php-ext-install mysqli >/dev/null
RUN docker-php-ext-install opcache >/dev/null
RUN docker-php-ext-install pcntl >/dev/null
RUN docker-php-ext-install pdo_mysql >/dev/null
RUN docker-php-ext-install shmop >/dev/null
RUN docker-php-ext-install sockets >/dev/null
RUN docker-php-ext-install sysvmsg >/dev/null
RUN docker-php-ext-install sysvsem >/dev/null
RUN docker-php-ext-install sysvshm >/dev/null
RUN docker-php-ext-install bz2 >/dev/null
RUN docker-php-ext-install bcmath >/dev/null
RUN docker-php-ext-install calendar >/dev/null
RUN docker-php-ext-install enchant >/dev/null
RUN docker-php-ext-install gd >/dev/null
RUN docker-php-ext-install gettext >/dev/null
RUN docker-php-ext-install gmp >/dev/null
RUN docker-php-ext-install mcrypt >/dev/null
RUN docker-php-ext-install pdo_pgsql >/dev/null
RUN docker-php-ext-install pgsql >/dev/null
RUN docker-php-ext-install recode >/dev/null
RUN docker-php-ext-install soap >/dev/null
RUN docker-php-ext-install tidy >/dev/null
RUN docker-php-ext-install xmlrpc >/dev/null
RUN docker-php-ext-install xsl >/dev/null
RUN docker-php-ext-install zip >/dev/null

#设置进入容器后的初始目录
WORKDIR /www
