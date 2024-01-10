# Klipper 'Wand' server upgrade

Against my nagging doubts I ordered the Wand server upgrade in January of 2024. These are my notes from testing it.

## Wand Server

[The introductory video](https://www.youtube.com/watch?v=tZTroe6rOa0) provides lots of clues about how Tiertime's Klipper design works.

## Klipperized Mainboard

![chrome_xYYNEMN8Am](https://github.com/Cellivar/3d-printing/assets/1441553/10bd542a-b7e4-4d35-a4e5-ad4188db2480)

The replacement mainboard is controlled by an [STM32F103RCT6](https://www.st.com/en/microcontrollers-microprocessors/stm32f103rc.html#overview).

Comparing the physical layout of the PCB it's clear that this is a revsion 2 of the original board.

My original mainboard is an `MB.2M.2104.vC2`. The disassembly video shows `MB.2M.2106.vC2` The new one is an `MB.2M.2107.STM.vC2`

The Tiertime SKU is `BC16002-2` for all boards. This may imply that all future Cetus2 units will start out with the Klipper system eventually, lending further credence to the idea of the original firmware platform being abandoned.

### Microcontroller

* 72MHz ARM Cortex M3 single-core.
* 256k Flash
* 48k SRAM
* 51 GPIO
* 3 SPI
* 2 I2C
* 5 USART
* 1 USB
* 1 CAN (lol)
* 1 SDIO
* 3x 12-bit ADC, 16 channels
* 2x 12-bit DAC, 2 channels

USB-C port on side of board is used for Klipper communication.

### Drivers

* TMC2225-SA for the X, Y, and Z.
* TT3240 for the extruder, a proprietary chip.

