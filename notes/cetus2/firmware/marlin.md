# Marlin Research

The stock firmware for the original Cetus2 motherboard appears to be a dead-end. The comapny has recently announced that the Cetus2 Wand Server

## Hardware

The Cetus2 mainboard uses an ESP32-S2-WROOM-I module as the primary CPU. There is a daughterboard for the screen that also uses the same ESP32-S2-WROOM-I module.

A photo of the mainboard is on [the electrical details page](../electrical.md).

The screen daughterboard manages

* Wifi network communication
* USB device-mode as a custom device for communication with wand.exe
* MicroSD card for file storage, including received files via wifi.
* Driving the TFT screen
* GPIO header control

An FFC cable conects the screen daughterboard to the mainboard. It's unclear how the two devices communicate, common candidates are serial and USB host/device mode.

The mainboard manages:

* 24v to 12v and 5v
* All motors and fans
* End stop signals and bed height flex sensor
* Nozzle heaters
* Heated bed
* Filament sensor input

### ESP32-S2 

The ESP32-S2-WROOM-I is an older single-core processor designed for IoT type of devices.

* 128k ROM
* 320k SRAM
* 4? MB flash storage (needs testing, downloadable firmware update package is ~2.25MB)
* 


The version on the original boards both have an external IPEX antenna connector for an external antenna. Only the screen board has an antenna connected.



## Firmware

### Original

The closed-source firmware is not available, however their website offers two downldoadable versions of firmware update packages. These packages are meant to be loaded on an SD card and applied via the update menu on the TFT screen.

I have not explored these files yet.

### Klipper

In late 2023 Tiertime began uploading videos to their youtube channel showing off the Wand server. [The first video](https://www.youtube.com/watch?v=XjaxJGwmU80), showing the setup process, very clearly showed Klipper as the controller software.

[The second video](https://www.youtube.com/watch?v=tZTroe6rOa0) then made it clear the entire motherboard and screen are completely replaced to support this. The new motherboard is a different processor as Klipper does not support ESP32s.

As of 2024-01-09 the wand server and motherboard are on sale for $160. Against my better judgement I have ordered the kit. Consider my actions carefully as you read my opinion anywher else in this repo.

### Marlin

Marlin has native support for ESP32 boards, and several forks have implemented ESP32-S2 support specifically.

* [ESP3D](https://esp3d.io/esp3d/index.html) has ESP32-S2 support.
* [ESP3D-TFT](https://esp3d.io/esp3d-tft/index.html) is a similar library for driving TFT touchscreen controllers, and may drop onto the screen daughterboard directly.
* [Simon Jouet forked marlin](https://github.com/simon-jouet/Marlin) and got the ESP32-S2 working in [his controller project](https://github.com/simon-jouet/ESP32Controller).

The Cetus2 firmware update file contains a pin mapping configuration file that could be used to configure Marlin.
