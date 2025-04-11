FROM debian:stable

RUN apt update
RUN apt install -y nginx php8.2-fpm libnginx-mod-http-image-filter

COPY ./etc_nginx /etc/nginx
#RUN ls /tmp
#RUN mv /tmp/etc_nginx/* /etc/nginx
#RUN rmdir /tmp/etc_nginx

COPY ./var_www_html /var/www/html
#RUN mv /tmp/var_www_html/* /var/www/html
#RUN rmdir /tmp/var_www_html

RUN useradd app
USER app

CMD ["nginx", "-s", "reload"]
