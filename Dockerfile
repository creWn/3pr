# syntax=docker/dockerfile:1
FROM python:3.12-slim

# Создаём непривилегированного пользователя
RUN useradd --create-home --shell /bin/bash proxy

# Устанавливаем proxy.py
RUN pip install --no-cache-dir proxy.py==2.4.4

# Рабочая директория (опционально)
WORKDIR /home/proxy

# Порт по умолчанию (можно переопределить через -e PROXY_PORT=...)
ENV PROXY_PORT=8899

# Учётные данные (обязательно задать при запуске)
ENV PROXY_USER=proxyuser
ENV PROXY_PASS=proxypass

# Переключаемся на обычного пользователя
USER proxy

EXPOSE ${PROXY_PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${PROXY_PORT}')" || exit 1

ENTRYPOINT ["sh", "-c", \
    "proxy --hostname 0.0.0.0 --port ${PROXY_PORT} --basic-auth ${PROXY_USER}:${PROXY_PASS}"]
