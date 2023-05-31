ARG adminerVersion=4.8.1

FROM adminer:$adminerVersion
LABEL maintainer="labring"

USER root
RUN apt-get update && \
    apt-get install -y autoconf gcc g++ make libffi-dev libssl-dev && \
    pecl install mongodb && \
    echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/docker-php-ext-mongodb.ini
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER adminer

COPY themes/bilal-dark.css /var/www/html/adminer.css
COPY plugins-enabled/AdminerCollations.php plugins-enabled/AdminerJsonPreview.php plugins-enabled/AdminerSimpleMenu.php plugins-enabled/LoginServer.php /var/www/html/plugins-enabled/
COPY plugins/ClickLogin.php /var/www/html/plugins/ClickLogin.php