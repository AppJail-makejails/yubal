ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/base:${FREEBSD_RELEASE}

ARG PYVER

LABEL org.opencontainers.image.title="Yubal" \
    org.opencontainers.image.description="Self-hosted YouTube Music downloader" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/yubal" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/yubal" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN pkg update && \
    pkg install -y py${PYVER}-yubal-api && \
    pkg clean -a && \
    rm -rf /var/cache/pkg/* /var/db/pkg/repos/*

ENV PYTHONUNBUFFERED=1 \
    YUBAL_ROOT=/usr/local/www/yubal-api \
    YUBAL_DATA=/var/db/yubal/data \
    YUBAL_CONFIG=/var/db/yubal/config \
    YUBAL_HOST=0.0.0.0 \
    YUBAL_PORT=8000

COPY entrypoint.sh /entrypoint.sh
RUN sed -i '' -Ee 's/%%PYVER%%/${PYVER}/g' /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER www
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
