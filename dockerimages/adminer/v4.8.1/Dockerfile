ARG adminerVersion=4.8.1

FROM adminer:$adminerVersion
LABEL maintainer="labring"

USER root
RUN apt-get update \
&&  buildDeps='php7.4-mongodb' \
&&  apt-get install -y $buildDeps --no-install-recommends \
&&  apt-get purge -y --auto-remove $buildDeps
USER adminer

COPY themes/bilal-dark.css /var/www/html/adminer.css
COPY plugins-enabled/AdminerCollations.php plugins-enabled/AdminerJsonPreview.php plugins-enabled/AdminerSimpleMenu.php plugins-enabled/LoginServer.php /var/www/html/plugins-enabled/
COPY plugins/ClickLogin.php /var/www/html/plugins/ClickLogin.php