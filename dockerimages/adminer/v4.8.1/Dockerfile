ARG adminerVersion=4.8.1

FROM adminer:$adminerVersion
LABEL maintainer="labring"

RUN apk add autoconf gcc g++ make libffi-dev openssl-dev
RUN pecl install mongodb
RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/docker-php-ext-mongodb.ini

COPY themes/bilal-dark.css /var/www/html/adminer.css
COPY plugins-enabled/AdminerCollations.php plugins-enabled/AdminerJsonPreview.php plugins-enabled/AdminerSimpleMenu.php plugins-enabled/LoginServer.php /var/www/html/plugins-enabled/
COPY plugins/ClickLogin.php /var/www/html/plugins/ClickLogin.php