# Cetus2 Printer Notes

Against my better judgment I preordered a Cetus2 printer shortly after the Kickstarter was successful in early 2022.

You can now purchase this printer [directly from their website](https://www.cetus3d.com/product/cetus2-3d-printer/).

As is usually the case the original ship dates in early 2022 slid until I received my order in January 2023 as part of the last Kickstarter shipment to backers. 

I have found mild success, been impressed by the hardware, and disapointed in the software. These notes are for my own reference as I start to consider the flexibility that comes from having a good understanding of the capabilities of one's tools. 

As a software engineer, DevOps automation engineer, and dabbler of electronics I'm interested in taking this printer to the limits of what it can do. Anything major I do will be recorded here. 

## Notes

* [Electrical systems](electrical.md), including pinouts. 
* [Extruder head](extruder_v2.md), a fairly self-contained module that wouldn't be too hard to swap out. 
* [Filament sensor](filament_sensor.md), the official add-on.
* [Printable parts files](parts_files)

### Other Websites

* Dan's [KautzCraft site](https://dimensionalprint.kautzcraft.studio/fdm-fused-deposition-modeling/cetus2) notes, who is also diving deep into the design of the Cetus2.
* [Cetus 3D Facebook Group](https://www.facebook.com/groups/1969652873204562) (I don't use FB so I'm not on there)
* [Cetus2 official forum](https://forum.tiertime.com/c/cetus3d/cetus2/30) (Fairly quite)
* [Cetus3D Subreddit](https://old.reddit.com/r/cetus3d/) (Fairly quiet)

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

* [Buy parts from their website](https://www.cetus3d.com/all-products/)
  * [Nozzles, 0.6 and 0.8mm (at time of writing)](https://www.cetus3d.com/product/otfs-brass-nozzle/)
  * [Build plate](https://www.cetus3d.com/product/cetus2-carborundum-glass-build-plate/)
  * [Internal extruder PTFE replacements](https://www.cetus3d.com/product/cetus2-extruder-ptfe-tubepack-of-6/)
  
Shipping from China takes a while, plan accordingly.
  
### Carborundum Glass Build Plate

* Can [get it from their store](https://www.cetus3d.com/product/cetus2-carborundum-glass-build-plate/). Shipping takes a while from their China shop, be prepared.

This is a coated textured glass build plate that comes with the machine, one side is coated with (what seems to be) a carborundum material and the other side is bare glass, giving you options for printing. It's fairly thick, solid, nicely ground corners and the texture of the coating is not very pronounced. The prints I pulled off of it just barely show the texture, and came off with minimal scraping.

I did not have adhesion issues until after the first few prints. It seems that [the coatings are sensitive to skin oils](https://all3dp.com/2/3d-printer-bed-how-to-choose-the-right-build-plate/) and really must be washed with **soap and water** after every few prints.

After several more successful prints I noticed a growing layer of PLA building up on the print surface. I tried to avoid this by moving the prints around the plate until it really was covering too much. I then tried using IPA and then acetone to clean it off and was not successful. I have a second plate coming in the mail, once it arrives I will feel more comfortable performing experiments on my initial build plate, if I learn something interesting I'll note it here.

Printing PETG directly onto the coated side resulted in successful prints that were VERY difficult to remove, I had to carefully pry and wiggle the prints to get them off the bed without damaging the prints or the bed. My printer came with a glue stick and I started using that to help release PETG prints, after which I had no issues popping them off once the print was done.

### Filament Monitoring

See the [separate notes page](filament_sensor.md) on the filament monitor.

You can purchase this [directly from their store](https://www.cetus3d.com/product/cetus2-filament-monitor-module/) if your printer didn't come with it.

This came with the deluxe package (which I got) and is a small metal box that fits on the back of the Z axis metal frame. It includes both microswitches and hall-effect filament motion sensors. 

The printer will pause a print and keep the heated bed going if it detects the filament is moving too slow, not at all, or has been cut or run out. 

Mine was fiddly at first, especially with the included samples. It had several false positive build pauses and I disabled it for a while. After some fiddling, my modification to move it up higher, and my filament dryboxes the module is working. It has saved me a couple of prints, and while I had it turned off I had a print fail due to a filament tangle. If your printer pauses a lot from this sensor try adjusting how the filament feeds in and the angles of the bowden tubes to makes sure everything is rolling smoothly.

I haven't analyzed how the module communicates back to the mainboard, it's unlikely something that would be easy to DIY. It's very likely easier to just order the official one.

### Wand print server

As of writing [this is available for pre-order with an estimate ship date of April.](https://www.cetus3d.com/product/cetus2-wand-controller/)

The Wand software but in a standalone box and duplicating features of Octokit. Expected to support to 8 printers with 4 cameras (one at a for time) for streaming. Unclear if the software can be run elsewhere like on a NAS.

This may be useful for further protocol understanding. 

### Automated Build Plate

As of writing [this is available for pre-order with an estimated ship date of July 2023](https://www.cetus3d.com/product/cetus2-automatic-build-platform/).

A system for replacing the stock bed platform with a mechanism to swap out the print bed between prints. Lets you put the printer into an automated printing loop for as many plates as you can load. Still in development. 
