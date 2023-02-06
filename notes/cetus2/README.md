# Cetus2 Printer Notes

Against my better judgment I preordered a Cetus2 printer shortly after the Kickstarter was successful in early 2022.

As is usually the case the original ship dates in early 2022 slid until I received my order in January 2023 as part of the last Kickstarter shipment to backers. 

I have found mild success, been impressed by the hardware, and disapointed in the software. These notes are for my own reference as I start to consider the flexibility that comes from having a good understanding of the capabilities of one's tools. 

As a software engineer, DevOps automation engineer, and dabbler of electronics I'm interested in taking this printer to the limits of what it can do. Anything major I do will be recorded here. 

## Notes

* [Electrical systems](electrical.md), including pinouts. 
* [Extruder head](extruder_v2.md), a fairly self-contained module that wouldn't be too hard to swap out. 
* [Filament sensor](filament_sensor.md), the official add-on.

### General behavioral notes

The firmware as of 2023-02-05 will initialize _without the extruder attached at all_. This is very promising for using the printer for other purposes, such as a laser cutter head.

## Official Features (And notes about them)

[![Kickstarter early promises](https://ksr-ugc.imgix.net/assets/035/910/268/c8e781036ce6dd80b34adf8b49d6e5ee_original.jpg?ixlib=rb-4.0.2&w=680&fit=max&v=1640232035&gif-q=50&q=92&s=caa7e1f60c07ba8bdf477837b43ad1a9)](https://www.kickstarter.com/projects/cetus/cetus2-3d-printing-with-material-and-color-mixing-innovation)

* Build volume: 200mmX x 300mmY x 300mmZ
* Extruder max temp: 260
* Heated bed max temp: 100
* Connectivity: USB-C, Wi-Fi, SD Card
* Build plate: Borosilicate glass (Except for cheap model that didn't get this)
* Controller: ESP32
    * Two, technically, the second ESP32 drives the touchscreen and wifi.
* Firmware: Custom, closed source.
    * There were plans to support an open source firmware [which was cancelled and refunded in update 20.](https://www.kickstarter.com/projects/cetus/cetus2-3d-printing-with-material-and-color-mixing-innovation)
    * The Kickstarter also offered support with third party slicers, which hasn't arrived yet. 
    * Third party slicer support was caveated that they likely wouldn't support the dual extrusion features. 
    * Octoprint support was also promised and isn't available yet. [A tweet mentions support in 2021](https://twitter.com/TiertimeCorp/status/1435913995987292168) and there has been no follow-up.
    * Third party gcode support is mentioned and hasn't really shipped. [What is documented is pretty old](https://support.tiertime.com/hc/en-us/articles/360001465934-Printing-with-Gcodes) and missing some useful commands. 

### The low-spec version

Originally the Kickstarter had an option for a basic low spec version, which was removed to avoid the complexity of having lower quality components in stock to build them.

## Official add-ons

### Filament Monitoring

See the [separate notes page](filament_sensor.md) on the filament monitor.

This came with the deluxe package (which I got) and is a small metal box that fits on the back of the Z axis metal frame. It includes both microswitches and hall-effect filament motion sensors. 

The printer will pause a print and keep the heated bed going if it detects the filament is moving too slow, not at all, or has been cut or run out. 

Mine was fiddly at first, especially with the included samples. It had several false positive build pauses and I disabled it for a while. After some fiddling, my modification to move it up higher, and my filament dryboxes the module is working. It has saved me a couple of prints, and while I had it turned off I had a print fail due to a filament tangle.

This module isn't super basic and is probably worth the upgrade instead of DIY.

### Wand print server

The Wand software but in a standalone box and duplicating features of Octokit. Expected to support to 8 printers with 4 cameras (one at a for time) for streaming. Unclear if the software can be run elsewhere like on a NAS.

This may be useful for further protocol understanding. 

### Automated Build Plate

A system for replacing the stock bed platform with a mechanism to swap out the print bed between prints. Lets you put the printer into an automated printing loop for as many plates as you can load. Still in development. 
