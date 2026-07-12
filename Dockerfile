# syntax=docker/dockerfile:1
FROM python:3.12-slim

# Создаём непривилегированного пользователя с уникальным именем
RUN useradd --create-home --shell /bin/bash proxyuser

# Устанавливаем proxy.py
RUN pip install --no-cache-dir proxy.py==2.4.4

WORKDIR /home/proxyuser

# Переменные окружения для настройки
ENV PROXY_PORT=8899
ENV PROXY_USER=proxyuser
ENV PROXY_PASS=proxypass

USER proxyuser

EXPOSE ${PROXY_PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${PROXY_PORT}')" || exit 1

ENTRYPOINT ["sh", "-c", \
    "proxy --hostname 0.0.0.0 --port ${PROXY_PORT} --log-level d"]
