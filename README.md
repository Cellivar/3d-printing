# 3d-printing

Anything I find useful to version control about my forays into 3d printing

## Printers

### Bildhauerkabine - Voron T0+50, Serial V0.4299

My first kit printer is a custom Voron v0 build modded with the TriZero Plus50, BoxZero, and ZeroPanels. I've also added a variety of other mods and features to it.

* [Notes on the Voron V0](/notes/voron_v0/README.md)

![bildhauerkabine](/notes/bildhauerkabine.jpg)

### Over-The-Range Microwave Oven (OTRMO) - Heavily modified Cetus 2

My first 3D printer is a Cetus2 from Tiertime delivered in 2023, which I used to cut my teeth on 3D printing. I quickly learned that what I had purchased was a frustration machine that occasionally acted like a 3D printer. The printer's firmware and software toolchain was terrible, which lead to a lot of problems with printing. After the V0 turned out to be light years ahead in stability and print quality I began to modify the Cetus2. After mid-2024 it no longer resembled the original printer, and by mid-2025 it was sufficiently ship-of-theseus'd to the point of barely acting like the original printer. And I had little interest in mentioning the original manufacturer at that point.

Why the name? As an open-frame printer in a garage it needed to be protected from drafts. I had some sheets of cardboard that I could cut up...

| Initial cardboard door work | After some improvements |
| --- | --- |
| ![img](/notes/otrmo_box.jpg) | ![img](/notes/otrmo_windows.jpg) |

## Configs

My home network runs on a Nomad cluster, and my printers are part of that cluster. I use the configs in the [terraform directory](./terraform/README.md) to deploy the printer jobs to the cluster and manage publishing the config files to Consul. This makes working on configs via Git and Visual Studio Code very easy for me.

## Old Cetus2 notes

These are notes for the pre-modification Cetus2 printer hardware and software. I'm no longer updating them.

* [Notes on the Cetus2 printer](/notes/cetus2/README.md)
  * [Notes on the Cetus2 3D printed parts](/notes/cetus2/parts_files/README.md)
* [Notes on the UP Studio3 software from Tiertime/Cetus3D](/archive/up_studio_3/README.md)
  * [Configurations that I got working well for UP Studio3 and my Cetus2](/archive/cetus2/configs/README.md)
