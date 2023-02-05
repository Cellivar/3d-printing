# Cetus2 Extruder Head V2

I'm calling this V2 because that's what's 3D printed on the side of the extruder shroud. That might be V2 of just the shroud but I've no idea and Tiertime haven't commented. Additionally, as other models have had improvements in the future. Given the cutting edge design of the dual nozzle setup I would be surprised if we don't see a new revision in the future to address any possible shortcomings.

I call out several thread sizes for screws in here, these are based on my $13 digital calipers and how easy it was to google for a dimension. It might be off slightly, maybe buy a kit of several sizes. [I tried to stick to the official guide for labelling them](https://www.fastenermart.com/understanding-metric-fasteners.html).

## Main unit and disassembly

Tiertime have very helpfully [provided a video on taking apart the extruder](https://www.youtube.com/watch?v=_V2NRECrV9I) which is a great intro into how to take the unit apart. I had to disassemble mine literally the day before this video was posted to fix a jam and boy howdy would it have been nice to have.

General notes:

1. Remove material and bowden guide tubes
2. Unplug all three fans
3. Ensure the white connectors on top aren't getting in the way of the shroud.

You can now slide the 3D printed extruder shroud off of the extruder frame. It's held in by some very aggressive dimples on either side of the top, behind the `V2 --->` text. Once you pop the shroud over those dimples it slides off the rest of the way fairly easily. 

In the video they suggest using the 12mm socket wrench the printer comes with to strike the top corner of the unit, to the side of the 24 pin IDC connector. I used a rubber deadblow hammer because I own one and it's a bit more gentle. You'll feel it slide much more easily after the first 0.5cm or so.

![image](https://user-images.githubusercontent.com/1441553/216794681-2701ead5-d420-4706-87df-1507c5c7c380.png)

The shroud is not struturally necessary, it's only for looking nice and holding the fans.

### Parts

### Extruder Electrical Board

Mounted to top 3D printed plate with two M2.5?-0.8?x7.5 phillips screws.

The arrows here identify pin 1, denoted by the square solder pad.

![image](https://user-images.githubusercontent.com/1441553/216796913-3664a22c-3c0b-497b-a23d-f21ae00aaeee.png)

* SKU BC1105-2 (Tiertime internal part number?)
* JST-alike connectors are from hxhconnector.com, can't find the right part numbers. 2.5mm pitch?
* 24 pin IDC rainbow cable `Pa2`
    1. Extruder 1 Pin 4
    2. Extruder 2 Pin 3
    3. Extruder 1 Pin 3
    4. Extruder 2 Pin 4
    5. Extruder 1 Pin 2
    6. Extruder 2 Pin 2
    7. Extruder 1 Pin 1
    8. Extruder 2 Pin 1
    9. Hotend 1 Pin 4
    10. Hotend 1 Pin 4
    11. Hotend Common (Pin 3 on both hotend connectors)
    12. Hotend Common
    13. Hotend Common
    14. Hotend Common
    15. Hotend 2 Pin 4
    16. Hotend 2 Pin 4
    17. Part fan -V
    18. Hotend fans -V (Pin 3 on both connectors)
    19. Fan Common +V (Pin 1 on all fan connectors, 12V constant??)
    20. Fan Common +V
    21. Hotend 1 Pin 1
    22. Hotend 2 Pin 1
    23. Hotend 1 Pin 2
    24. Hotend 2 Pin 2
* Motor 1 4 pin connector (White) `PDa1`
    1. Red: ?
    2. Yellow: ?
    3. Black: ?
    4. White: ?
* Motor 2 4-pin connector (White) `PDa2`
    1. Red: ?
    2. Yellow: ?
    3. Black: ?
    4. White: ?
* Hotend 1 4-pin connector (Red) `PA2-1`
    1. Blue: Temp probe
    2. Blue: Temp probe
    3. Red: Heater (8Ω?)
    4. Red: Heater
* Hotend 2 4-pin connector (Yellow) `PA2-2`
    1. Blue: Temp probe
    2. Blue: Temp probe
    3. Red: Heater (7.7Ω?)
    4. Red: Heater
* Hotend fan 3-pin connector (both are wired together) `Pf3`
    1. Red +12V
    2. Individually isolated and don't appear to be connected to anything else on the board?
    3. Black -V
* Part fan 2-pin connector `Pf2`
    1. Red +V variable
    2. Black -V

#### Extruder Stack

This is the full route of the filament thorugh the extruder module.

* 3D printed guide tray
    * Mounted to bracket with four M2.5-0.4x7.5 hex-head (2mm hex)
    * Don't over-tighten, threads are directly into 3D printed top bracket
* Small air gap
* Delrin? Tiertime custom extruder gear mechanism
    * Mounted to bracket with two M2.5-0.4x10 hex-head (2mm hex)
* FY-Motor 25BYHJ49-24B
    * No [exact match on their website](http://en.fy-motor.com/product/148.html) but similar models indicate:
    * Step angle: 7.5 degrees
    * 2 phases, 2 wires for each phase.
    * 12V 0.3A (constant current?) 20Ω 9.8mH
    * "Step avail": 1/47.32mm ?
    * Push torque: 900N
    * Shaft: ?mm x ??mm
    * Mounted to bracket with two M3-0.4x6 hex-head (2.5mm hex key)
* Small air gap
* PEEK-material tube holder mount
* PTFE tube into hotend
* Hotend tube with heatsink shroud, down to nozzle chamber
* Copper nozzle gasket
* Nozzle

#### Fans

##### Hotend cooling fans

* [Two of them](https://www.youtube.com/watch?v=btHpHjabRcc)
* 12v DC 2 wire (but 3 pin JST connector)
* 115mA current draw (each)
* 40mm x 11mm
* Screwed into extruder shroud with four M3x20 coarse thread phillips screws, self-tapping.

##### Part cooling fan

* 12v DC 2 wire, 2 pin JST connector
* 110mA current draw (ish, mine appears to have a noisy bearing so it drifted around)
* 30mm x 11mm
* Screwed to fan duct with four M3x14 coarse thread phillips screws, self-tapping.
* Fan duct is screwed to hotend heatsink with two M2.3?-0.4x8 hex-head screws (2mm hex)
