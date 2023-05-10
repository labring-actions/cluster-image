ARG adminerVersion=4.8.1

FROM adminer:$adminerVersion
MAINTAINER labring

COPY themes/adminer-dark-theme.css /var/www/html/adminer.css
COPY plugins-enabled/AdminerCollations.php plugins-enabled/AdminerJsonPreview.php plugins-enabled/AdminerSimpleMenu.php /var/www/html/plugins-enabled/
COPY plugins/AdminerLoginServers.php /var/www/html/plugins/AdminerLoginServers.php