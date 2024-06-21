# Tierbox Wand Server

The 'Wand Server' device, known as its default hostname of 'tierbox', is a SBC integrated touchscreen device. It was provided as part of the Klipperized mainboard upgrade kit for the Cetus2.

No, it's not worth buying. Get a RasPi 4 instead.

[Product page](https://www.cetus3d.com/product/cetus2-wand-controller/)

## Hardware

* [Baijie Helperboard A133](https://www.szbaijie.com/index/Goods/detail.html?language=en&goods_id=15) module
  * [Allwinner A133](https://linux-sunxi.org/A133) Quad-Core Cortex-A53 ARM CPU
  * 1GB RAM
  * 4(?) GB eMMC memory
  * Wifi, Ethernet, 4x USB 2.0 ports
  * SD card slot
  * Hidden USB-C OTG connection, possibly connected to debug UART(!?)
* 4.3" Resistive Touchscreen
* 12V Power Supply
* Piezo buzzer

## Software

As of 2024-06-12 you can SSH into the machine via `ssh tier@THE_IP_ADDRESS` using the password `tiertime`. It's recommended to immediately create a new user account to use instead as the update scripts may modify this account in the future.

The machine [uses Kiauh](https://github.com/dw-0/kiauh) to install the various Klipper components. Once you're in the machine you can run the update scripts as normal.

The operating system is some horrific mishmash of Ubuntu 22.04 with Linux Kernel 4.9.170, which shouldn't even be possible.

The boot config is set up in some bizzare layout involving multiple partitions of the eMMC disk.
