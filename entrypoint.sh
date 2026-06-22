#!/bin/sh
set -e

if [ -z "$PROXY_LOGIN" ] || [ -z "$PROXY_PASSWORD" ]; then
    echo "ОШИБКА: переменные PROXY_LOGIN и PROXY_PASSWORD должны быть установлены!"
    exit 1
fi

# Подставляем переменные в шаблон
envsubst < /etc/3proxy/3proxy.cfg.template > /etc/3proxy/3proxy.cfg

# Запускаем 3proxy
exec 3proxy /etc/3proxy/3proxy.cfg
