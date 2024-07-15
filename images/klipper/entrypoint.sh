#!/bin/bash
set -e

# Ensure the basic set of directories exist for Klipper to function
PRINTER_DATA=/home/klipper/printer_data
mkdir -p $PRINTER_DATA/run \
  $PRINTER_DATA/gcodes \
  $PRINTER_DATA/logs \
  $PRINTER_DATA/config
chown -R :1000 $PRINTER_DATA

if [[ -z "${SKIP_CREATE_PRINTER_CFG}" ]]; then
  # The printer.cfg file is required to boot, but is overwritten by Klipper too.
  # Create it only if it's missing. Everything else is in or referenced from main.cfg.
  [ -f $PRINTER_DATA/config/printer.cfg ] || echo '[include main.cfg]' > $PRINTER_DATA/config/printer.cfg
fi

# Run klipper
exec /home/klipper/venv/bin/python /home/klipper/klipper/klippy/klippy.py "$@"
