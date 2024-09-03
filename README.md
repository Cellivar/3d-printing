# 3d-printing

Anything I find useful to version control about my forays into 3d printing

## Printer

### Voron V0

My second printer is a custom Voron v0 build modded with the TriZero Plus50, BoxZero, and ZeroPanels. I've also added a variety of other mods and features to it.

* [Notes on the Voron V0.2](/notes/voron_v0/README.md)

### Cetus 2

My first 3D printer is a Cetus2 from Tiertime delivered in 2023, and it has been quite the adventure learning with it.

After Summer 2024 I ended up starting to modify the printer for additional print projects, the changes after 2024-08-08 should not be trusted to work on a stock Cetus2 machine!

* [Notes on the Cetus2 printer](/notes/cetus2/README.md)
  * [Notes on the Cetus2 3D printed parts](/notes/cetus2/parts_files/README.md)

## Slicers

* [Notes on the UP Studio3 software from Tiertime/Cetus3D](/archive/up_studio_3/README.md)
  * [Configurations that I got working well for UP Studio3 and my Cetus2](/archive/cetus2/configs/README.md)

## Configs

My home network runs on a Nomad cluster, and my printers are part of that cluster. I use the configs in the [terraform directory](./terraform/README.md) to deploy the printer jobs to the cluster and manage publishing the config files to Consul. This makes working on configs via Git and Visual Studio very easy for me.
