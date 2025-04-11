FROM debian:stable-slim

# Устанавливаем зависимости
RUN apt-get update && \
    apt-get install -y nginx php8.2-fpm libnginx-mod-http-image-filter sudo && \
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
ARG USERNAME=app
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
	&& useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
	&& chmod 0440 /etc/sudoers.d/$USERNAME

USER app

# Настраиваем права
RUN sudo chown -R app:app /var/www/html && \
    sudo chown -R app:app /etc/nginx

# Открываем порт
EXPOSE 80 443

# Запускаем сервисы
CMD sudo service php8.2-fpm start && sudo nginx -g "daemon off;"
