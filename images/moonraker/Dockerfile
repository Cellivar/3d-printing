# syntax=docker/dockerfile:1
## Get Code and Build venv
FROM docker.io/library/python:3.12-trixie AS build
WORKDIR /opt

ARG VERSION=master
ADD https://github.com/Arksine/moonraker.git#${VERSION} moonraker/

RUN --mount=type=bind,source=requirements-prind.txt,target=requirements-prind.txt \
  python -m venv venv \
  && venv/bin/pip install --no-cache-dir -r requirements-prind.txt \
  && venv/bin/pip install --no-cache-dir -r moonraker/scripts/moonraker-requirements.txt \
  && venv/bin/pip install --no-cache-dir -r moonraker/scripts/moonraker-speedups.txt

## Runtime Image
FROM docker.io/library/python:3.12-slim-trixie AS run

RUN apt update && apt install -y \
  libopenjp2-7 \
  python3-libgpiod \
  curl \
  libcurl4t64 \
  libssl3t64 \
  liblmdb0 \
  libsodium23 \
  libjpeg62-turbo \
  libtiff6 \
  libxcb1 \
  zlib1g \
  iproute2 \
  systemd \
  sudo \
  git \
  jq \
  && apt clean

RUN groupadd moonraker --gid 1000 \
  && useradd moonraker --uid 1000 --gid moonraker \
  && usermod moonraker --append --groups dialout

WORKDIR /home/moonraker

# Crate empty docs dirs to prevent an annoying warning
RUN mkdir -p /home/klipper/klipper/config /home/klipper/klipper/docs \
  && echo "Nothing to see here!" > /home/klipper/klipper/config/empty.md \
  && echo "Nothing to see here!" > /home/klipper/klipper/docs/empty.md \
  && chown -R moonraker:moonraker /home/klipper/*

ENV MOONRAKER_DATA_PATH="/home/moonraker/printer_data"

COPY --chmod=755 entrypoint.sh entrypoint.sh
COPY --chown=moonraker:moonraker --from=build /opt/moonraker ./moonraker
COPY --chown=moonraker:moonraker --from=build /opt/venv ./venv

## Start Moonraker
USER moonraker
EXPOSE 7125
ENTRYPOINT ["/home/moonraker/entrypoint.sh"]
