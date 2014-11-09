FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y wget && wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg
RUN echo "deb http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list
RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list

RUN apt-get update -y
RUN apt-get install -y nginx php5-fpm php5-mysqlnd php5-cli mysql-server supervisor

RUN sed -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' -i /etc/php5/cli/php.ini
RUN sed -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' -i /etc/php5/fpm/php.ini
RUN sed -e 's/;date\.timezone =/date.timezone = \"Europe\/Paris\"/' -i /etc/php5/cli/php.ini
RUN sed -e 's/;date\.timezone =/date.timezone = \"Europe\/Paris\"/' -i /etc/php5/fpm/php.ini
RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e "s/:33:33:/:1000:1000:/" -i /etc/passwd
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

RUN echo 'shell /bin/bash' > ~/.screenrc

ADD vhost.conf /etc/nginx/sites-available/default
ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf
ADD init.sh /init.sh

EXPOSE 80

VOLUME ["/srv"]
WORKDIR /srv

CMD ["/usr/bin/supervisord"]
