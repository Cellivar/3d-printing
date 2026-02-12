#!/bin/bash
set -e

# Ensure the basic set of directories exist for Klipper to function
PRINTER_DATA=/home/moonraker/printer_data
mkdir -p $PRINTER_DATA/run \
  $PRINTER_DATA/gcodes \
  $PRINTER_DATA/logs \
  $PRINTER_DATA/database \
  $PRINTER_DATA/config || (echo "Failed to create printer data directories"; sleep 500; exit 1)

#### TODO: DEFAULT MOONRAKER CONFIG SO IT CAN START UP AT LEAST?

# Run moonraker
exec /home/moonraker/venv/bin/python /home/moonraker/moonraker/moonraker/moonraker.py "$@"
