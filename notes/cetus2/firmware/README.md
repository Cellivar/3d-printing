# Printer Firmware

## Original Board

The original Cetus2 mainboard uses a proprietary firmware running on an ESP32-S2-WROOM-i module.

I don't know what the firmware is based on or if it's entirely homegrown. Given the weird support for gcode it may be entirely home grown, or a very old fork of something.

## Klipper Board

The 2024 Klipper controller upgrade consists of two pieces:

* Lightly modified Klipper image running on a separate control device with a screen.
* Replacement mainboard with a USB connection to the controller.

