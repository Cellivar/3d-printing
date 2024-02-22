# Voron V0.2 Notes

Having found 3D printing to be useful in general and somehow mustering the inner strength to refrain from defenestration of my first printer, I want to build a Voron V0.2.

To really seal the deal, I have also chosen to _start_ with a whole bunch of mods.

These are my notes as I fly by the seat of my pants into the world of Voron builds.

## The Plan

* [Voron v0.2 base](https://vorondesign.com/voron0.2)
* [Tri-Zero triple-belted-Z](https://github.com/zruncho3d/tri-zero)
* [Plus50 Mod, +50mm to build volume](https://github.com/zruncho3d/tri-zero/blob/main/PLUS50.md)
* [BozZero, removing top-hat from v0](https://github.com/zruncho3d/BoxZero)
* [ZeroPanels for sealing](https://github.com/zruncho3d/ZeroPanels)
* [Optical Z endstop](https://github.com/harry-boe/tri-zero/tree/main/Mods/hbo/Opto_Z_Endstop)
* [Servo dock for brush and z-probe](https://github.com/harry-boe/tri-zero/tree/main/Mods/hbo/ServoClick_And_Scrub)
* [Foldable spool holder](https://github.com/harry-boe/AntFarm-Projects/tree/main/PIP_Holder)
* [Zerofilters](https://github.com/zruncho3d/zerofilter)

Major Components:

* 180mm bed with 300w A/C heater
* E3D Revo Voron hotend
* LGX Lite Extruder
* [Mini Stealthburner LGX Lite mount](https://github.com/JackJack3231/MiniSB-Extruder-Mounts/blob/main/Extruder_Mounts/LGX-Lite/images/LGX_Lite_Minified.png)
* [BTT EBB36 CAN control board](https://github.com/bigtreetech/EBB)
* [CAN board mount](https://github.com/KayosMaker/CANboard_Mounts)
* [BTT Octopus v1.1](https://github.com/bigtreetech/BIGTREETECH-OCTOPUS-V1.0)
* [BTT Pi v1.2](https://github.com/bigtreetech/BTT-Pi)
* [BTT U2C CAN Interface](https://github.com/bigtreetech/U2C)

Software:

* [Armbian for the CB1](https://www.armbian.com/bigtreetech-cb1/)
* Nomad/Consul for managing services on the Pi.
* Klipper.
* Moonraker.
* Fluidd running remote in the cluster.

### The Goal

My Cetus2 produces as much frustration as it does successful prints. It has abilities no other printer has (no-purge color/material switching) that will remain useful long term.

* Start printing faster with less manual fiddling.
* Have much higher print success ratio.
* Print higher temp materials like ABS.
* Use OrcaSlicer.
* Add fully automated print support eventually.
