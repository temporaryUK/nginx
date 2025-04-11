FROM debian:stable-slim

# Устанавливаем зависимости
RUN apt-get update && \
    apt-get install -y nginx php8.2-fpm libnginx-mod-http-image-filter && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Создаем необходимые директории
RUN mkdir -p /run/nginx && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Копируем конфигурации
COPY ./etc_nginx /etc/nginx
COPY ./var_www_html /var/www/html

# Создаем пользователя (если действительно нужно)
RUN useradd -r -s /bin/false app

# Настраиваем права
RUN chown -R app:app /var/www/html && \
    chown -R app:app /etc/nginx

# Открываем порт
EXPOSE 80 443

# Запускаем сервисы
CMD service php8.2-fpm start && nginx -g "daemon off;"
