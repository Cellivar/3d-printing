# Bildhauerkabine - The Sculptor's Cubicle

Having found 3D printing to be useful in general and somehow mustering the inner strength to refrain from defenestration of my first printer, I built a new printer.

It went well.

## Goals

* Sealed for printing ASA/ABS in my basement garage without stinking up the house.
* Automate as much tedium as possible. Upload-home-level-print, with as little monitoring as needed.
* Use patterns common in the community to avoid 'magical' problems I have to investigate alone.
* Purple.

## The build

Bildhauerkabine is a Voron T0.2+B. Let's break that down.

* [Voron v0.2r1 base](https://vorondesign.com/voron0.2)
* [Tri-Zero triple-belted-Z](https://github.com/zruncho3d/tri-zero)
* [Plus50 to increase build size](https://github.com/zruncho3d/tri-zero/blob/main/PLUS50.md)
* [BozZero, removing top-hat from v0](https://github.com/zruncho3d/BoxZero)

This makes for a 280mm x 280mm x 470mm box within which the sculptor toils away at my behest.

Additional items:

* [Custom modified skirts from hbo](https://github.com/harry-boe/tri-zero/tree/main/Mods/hbo/SkirtsCollection)
* [ZeroPanels for sealing](https://github.com/zruncho3d/ZeroPanels)
* [Optical Z endstop](https://github.com/harry-boe/tri-zero/tree/main/Mods/hbo/Opto_Z_Endstop)
* [ServoKlicky with Euclid dock](https://github.com/harry-boe/tri-zero/tree/main/Mods/hbo/ServoClick_And_Scrub)
* [Zerofilters](https://github.com/zruncho3d/zerofilter)
* [180mm Annex K3 magbed](https://mandalaroseworks.com/products/annex-k3-magbed?variant=42237222846717) with 300W A/C heater

On the electronics side:

* RasPi 4B, connected via ethernet
* [BTT Octopus v1.1](https://github.com/bigtreetech/BIGTREETECH-OCTOPUS-V1.0)
* [PiCAN adapter](https://github.com/xbst/PiCAN)
* [BTT Mini 12864](https://github.com/bigtreetech/MINI-12864)

Current toolhead:

* [BTT EBB36 CAN control board](https://github.com/bigtreetech/EBB)
* Stock Voron V0.2r1 StealthBurner
* E3D Revo Voron hotend

Future considerations:

* [Mini Stealthburner LGX Lite mount](https://github.com/JackJack3231/MiniSB-Extruder-Mounts/blob/main/Extruder_Mounts/LGX-Lite/images/LGX_Lite_Minified.png)
* [CAN board mount](https://github.com/KayosMaker/CANboard_Mounts)

Software:

* Nomad/Consul for managing services on the Pi
* Klipper
* Moonraker
* Fluidd, running remote in the cluster
* KlipperScreen and Crowsnest running on a separate machine near the printer
