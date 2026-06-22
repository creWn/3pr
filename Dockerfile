# ---------- Этап сборки ----------
FROM alpine:latest AS builder

# Устанавливаем компилятор и утилиты
RUN apk add --no-cache \
    gcc \
    make \
    musl-dev \
    linux-headers \
    curl \
    tar

# Скачиваем и распаковываем исходники (последняя стабильная версия 0.9.4)
ENV 3PROXY_VERSION=0.9.4
RUN curl -L https://github.com/3proxy/3proxy/archive/refs/tags/${3PROXY_VERSION}.tar.gz | tar xz && \
    cd 3proxy-${3PROXY_VERSION} && \
    make -f Makefile.Linux

# ---------- Финальный образ ----------
FROM alpine:latest

# Устанавливаем gettext для envsubst (подстановка переменных)
RUN apk add --no-cache gettext

# Копируем собранный бинарник из этапа сборки
COPY --from=builder /3proxy-${3PROXY_VERSION}/bin/3proxy /usr/local/bin/3proxy

WORKDIR /etc/3proxy

# Копируем шаблон конфига и entrypoint-скрипт
COPY 3proxy.cfg.template ./
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3128 1080

ENTRYPOINT ["/entrypoint.sh"]
