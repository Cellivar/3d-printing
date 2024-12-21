# syntax=docker/dockerfile:1
## Get Klipper Source and Build venv
FROM python:3.11-bookworm AS build
WORKDIR /opt

RUN apt update && apt install -y cmake

ARG VERSION=master
ADD https://github.com/Klipper3d/klipper.git#${VERSION} klipper/

RUN --mount=type=bind,source=requirements-prind.txt,target=requirements-prind.txt \
  python -m venv venv \
  && venv/bin/pip install --no-cache-dir -r requirements-prind.txt \
  && venv/bin/pip install --no-cache-dir -r klipper/scripts/klippy-requirements.txt \
  && venv/bin/python -m compileall klipper/klippy \
  && venv/bin/python klipper/klippy/chelper/__init__.py

## Klippy Runtime Image
FROM python:3.11-slim-bookworm AS run

RUN groupadd klipper --gid 1000 \
  && useradd klipper --uid 1000 --gid klipper \
  && usermod klipper --append --groups dialout \
  && usermod klipper --append --groups tty

WORKDIR /home/klipper

COPY --chmod=755 entrypoint.sh entrypoint.sh
COPY --chown=klipper:klipper --from=build /opt/klipper ./klipper
COPY --chown=klipper:klipper --from=build /opt/venv ./venv

# Kippy Extras that add features
# Nevermore sensors for SGP40 - https://github.com/nevermore3d/Nevermore_Max/tree/master/Software/Klipper
ADD --chown=klipper:klipper https://github.com/nevermore3d/Nevermore_Max/raw/master/Software/Klipper/sgp40.py ./klipper/klippy/extras
ADD --chown=klipper:klipper https://github.com/nevermore3d/Nevermore_Max/raw/master/Software/Klipper/voc_algorithm.py ./klipper/klippy/extras
# Auto nozzle z calibrate - https://github.com/protoloft/klipper_z_calibration
ADD --chown=klipper:klipper https://github.com/protoloft/klipper_z_calibration/raw/master/z_calibration.py ./klipper/klippy/extras

USER klipper
ENTRYPOINT [ "/home/klipper/entrypoint.sh" ]
CMD ["-I", "printer_data/run/klipper.tty", "-a", "printer_data/run/klipper.sock", "printer_data/config/printer.cfg"]
###

## Image for building MCU code including other tooling
FROM debian:bookworm AS build-hostmcu
WORKDIR /opt

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
  sudo \
  virtualenv python3-dev libffi-dev build-essential pkg-config\
  libncurses-dev \
  avrdude gcc-avr binutils-avr avr-libc \
  stm32flash dfu-util libnewlib-arm-none-eabi \
  gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0-0 libusb-1.0-0-dev \
  python3-numpy python3-matplotlib usbutils python3-serial

COPY --from=build /opt/klipper ./klipper
COPY --from=build /opt/venv ./venv

#RUN --mount=type=bind,source=config.hostmcu,target=/opt/klipper/.config \
#  cd /opt/klipper && make flash

# ## Runtime image for the klipper_mcu binary
# FROM debian:bookworm-slim AS hostmcu

# RUN apt update && apt install -y gpiod
# COPY --from=build-hostmcu /usr/local/bin/klipper_mcu /usr/local/bin/klipper_mcu

# RUN mkdir -p /opt/printer_data/run
# ENTRYPOINT ["/usr/local/bin/klipper_mcu"]
# CMD ["-I", "/opt/printer_data/run/klipper_host_mcu.tty"]
# ###
