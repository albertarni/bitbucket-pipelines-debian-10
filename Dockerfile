FROM debian:buster-slim
MAINTAINER Damien Debin <damien.debin@smartapps.fr>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

RUN \
 apt-get update &&\
 apt-get -y --no-install-recommends install curl wget locales apt-utils &&\
 echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&\
 locale-gen en_US.UTF-8 &&\
 /usr/sbin/update-locale LANG=en_US.UTF-8 &&\
 echo "mysql-server mysql-server/root_password password root" | debconf-set-selections &&\
 echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections &&\
 apt-get -y --no-install-recommends install ca-certificates gnupg git subversion imagemagick openssh-client curl software-properties-common gettext zip unzip default-mysql-server default-mysql-client apt-transport-https ruby python python3 perl memcached geoip-database make ffmpeg gnupg2 &&\
 curl -sSL https://deb.nodesource.com/setup_10.x | bash - &&\
 wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - &&\
 echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.x.list &&\
 apt-get update &&\
apt-get -y --no-install-recommends install php7.4-apcu php7.4-bcmath php7.4-cli php7.4-curl php7.4-gd php7.4-geoip php7.4-gettext php7.4-imagick php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-pgsql php7.4-sqlite3 php7.4-xdebug php7.4-xml php7.4-xmlrpc php7.4-zip php7.4-memcached php7.4-redis nodejs ghostscript &&\
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/log/*

RUN \
 sed -ri -e "s/^variables_order.*/variables_order=\"EGPCS\"/g" /etc/php/7.4/cli/php.ini &&\
 echo "\nmemory_limit=-1" >> /etc/php/7.4/cli/php.ini &&\
 echo "xdebug.max_nesting_level=250" >> /etc/php/7.4/mods-available/xdebug.ini

RUN \
 curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
 curl -sSL https://phar.phpunit.de/phpunit.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit &&\
 curl -sSL https://codeception.com/codecept.phar -o /usr/bin/codecept && chmod +x /usr/bin/codecept &&\
 curl -sSL https://github.com/infection/infection/releases/download/0.12.0/infection.phar -o /usr/bin/infection && chmod +x /usr/bin/infection &&\
 npm install --no-color --production --global gulp-cli webpack mocha grunt yarn n &&\
 rm -rf /root/.npm /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/log/*
