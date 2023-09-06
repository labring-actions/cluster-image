FROM php:7.2-fpm

# change source
# RUN sed -i s/deb.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && sed -i s/security.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list

# base extension built in
RUN docker-php-ext-install fileinfo opcache

# databases
# ADD https://ghproxy.com/https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions redis mongodb pcntl pdo_mysql zip

# imagick
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*                                                    && \
    pecl install imagick                                                           && \
    docker-php-ext-enable imagick

# sourceguardian
RUN PHP_VERSION=$(php -v | head -n1 | cut -d' ' -f2 | cut -d. -f1-2)                                   && \
    mkdir -p /tmp/sourceguardian                                                                       && \
    cd /tmp/sourceguardian                                                                             && \
    curl -Os https://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz               && \
    tar xzf loaders.linux-x86_64.tar.gz                                                                && \
    cp ixed.${PHP_VERSION}.lin "$(php -i | grep '^extension_dir =' | cut -d' ' -f3)/sourceguardian.so" && \
    echo "extension=sourceguardian.so" > /usr/local/etc/php/conf.d/15-sourceguardian.ini               && \
    rm -rf /tmp/sourceguardian

# https://hub.docker.com/_/php
# https://github.com/mlocati/docker-php-extension-installer
# https://developers.weixin.qq.com/minigame/dev/wxcloudrun/src/scene/build/phpsg11.html