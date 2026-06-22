# Базовый образ Alpine Linux
FROM alpine:latest

# Устанавливаем 3proxy и полезные утилиты (опционально)
RUN apk add --no-cache 3proxy

# Создаём рабочую директорию для конфига
WORKDIR /etc/3proxy

# Копируем ваш конфигурационный файл (назовём его 3proxy.cfg)
COPY 3proxy.cfg ./

# Открываем стандартные порты:
# 3128 – HTTP/HTTPS-прокси, 1080 – SOCKS5
EXPOSE 3128 1080

# Запускаем 3proxy с указанием конфига
CMD ["3proxy", "/etc/3proxy/3proxy.cfg"]
