# syntax=docker/dockerfile:1
## Get Kalico Source and Build venv
FROM docker.io/library/python:3.12-trixie AS build
WORKDIR /opt

RUN apt update && apt install -y cmake && apt clean

ARG VERSION=main
ADD https://github.com/KalicoCrew/kalico.git#${VERSION} klipper/

RUN --mount=type=bind,source=requirements-prind.txt,target=requirements-prind.txt \
  python -m venv venv \
  && venv/bin/pip install --no-cache-dir -r requirements-prind.txt \
  && venv/bin/pip install --no-cache-dir -r klipper/scripts/klippy-requirements.txt \
  && venv/bin/python -m compileall klipper/klippy \
  && venv/bin/python klipper/klippy/chelper/__init__.py

## Klippy Runtime Image
FROM docker.io/library/python:3.12-slim-trixie AS run

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
# RGB barf - https://github.com/julianschill/klipper-led_effect
ADD --chown=klipper:klipper https://github.com/julianschill/klipper-led_effect/raw/master/src/led_effect.py ./klipper/klippy/extras

# AFC Klipper Addon - https://github.com/ArmoredTurtle/AFC-Klipper-Add-On/tree/main
# These steps are derived from their interactive installer. This will only set up
# the klipper extra files, not the macros which I store elsewhere.
ADD --chown=klipper:klipper https://github.com/ArmoredTurtle/AFC-Klipper-Add-On.git /home/klipper/AFC-Klipper-Add-On
RUN cp /home/klipper/AFC-Klipper-Add-On/extras/*.py ./klipper/klippy/extras/

USER klipper
ENTRYPOINT [ "/home/klipper/entrypoint.sh" ]
CMD ["-I", "printer_data/run/klipper.tty", "-a", "printer_data/run/klipper.sock", "printer_data/config/printer.cfg"]
###

## Image for building MCU code including other tooling
FROM docker.io/library/debian:trixie AS build-hostmcu
WORKDIR /opt

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
  sudo \
  virtualenv python3-dev libffi-dev build-essential pkg-config\
  libncurses-dev \
  avrdude gcc-avr binutils-avr avr-libc \
  stm32flash dfu-util libnewlib-arm-none-eabi \
  gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0-0 libusb-1.0-0-dev \
  python3-numpy python3-matplotlib usbutils python3-serial \
  && apt clean

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
