ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG PYVER
ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Yubal" \
    org.opencontainers.image.description="Self-hosted YouTube Music downloader" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/yubal" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/yubal" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -y py${PYVER}-yubal-api; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

ENV PYTHONUNBUFFERED=1 \
    YUBAL_ROOT=/usr/local/www/yubal-api \
    YUBAL_DATA=/data \
    YUBAL_CONFIG=/config \
    YUBAL_HOST=0.0.0.0 \
    YUBAL_PORT=8000

VOLUME ["/data", "/config"]

COPY entrypoint.sh /entrypoint.sh
RUN sed -i '' -Ee "s/%%PYVER%%/${PYVER}/g" /entrypoint.sh && \
    chmod +x /entrypoint.sh

EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
