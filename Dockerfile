FROM ubuntu:latest

RUN apt update && apt upgrade -y && apt-get install apache2 -y

WORKDIR /var/www/html

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]