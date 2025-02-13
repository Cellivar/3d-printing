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

The shroud is not structurally necessary, it's only for looking nice and holding the fans.

### Parts

### Extruder Electrical Board

Mounted to top 3D printed plate with two M2.5?-0.8?x7.5 phillips screws.

The arrows here identify pin 1, denoted by the square solder pad.

![image](https://user-images.githubusercontent.com/1441553/216796913-3664a22c-3c0b-497b-a23d-f21ae00aaeee.png)

| Name                      | Pin | Pin | Name                      |
| ------------------------- | --- | --- | ------------------------- |
| Extruder 1 Pin 4          | 1   | 2   | Extruder 2 pin 3?         |
| Extruder 1 Pin 3          | 3   | 4   | Extruder 2 pin 4?         |
| Extruder 1 Pin 2          | 5   | 6   | Extruder 2 pin 2          |
| Extruder 1 pin 1          | 7   | 8   | Extruder 2 pin 1          |
| Hotend 1 pin 4 heater     | 9   | 10  | Hotend 1 pin 4 heater     |
| Hotend common pin 3       | 11  | 12  | Hotend common pin 3       |
| Hotend common pin 3       | 13  | 14  | Hotend common pin 3       |
| Hotend 2 pin 4 heater     | 15  | 16  | Hotend 2 pin 4 heater     |
| Part fan -V variable      | 17  | 18  | Hotend fans -V constant   |
| Fan common +V12 pin 1     | 19  | 20  | Fan common +V12 pin 1     |
| Hotend 1 pin 1 thermistor | 21  | 22  | Hotend 2 pin 1 thermistor |
| Hotend 1 pin 2 thermistor | 23  | 24  | Hotend 2 pin 2 thermistor |

* SKU BC1105-2 (Tiertime internal part number?)
* JST-alike connectors are from hxhconnector.com, can't find the right part numbers. 2.5mm pitch?
* 24 pin IDC rainbow cable `Pa2`
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
    2. _Not connected_
    3. Black -V constant
* Part fan 2-pin connector `Pf2`
    1. Red +12V
    2. Black -V controlled

#### Extruder Stack

This is the full route of the filament through the extruder module.

* 3D printed guide tray
    * Mounted to bracket with four M2.5-0.4x7.5 hex-head (2mm hex)
    * Don't over-tighten, threads are directly into 3D printed top bracket
* Small air gap
* Stepper motor
    * Mounted to bracket with two M3-0.4x6 hex-head screws (2.5mm hex key)
* Delrin? Tiertime custom extruder gear mechanism
    * Mounted to bracket with two M2.5-0.4x10 hex-head screws (2mm hex)
    * Once screws are removed the delrin take significant force to slide off of the mount. You DO NOT need to remove the e-clip on the shaft to get the delrin off.
* Small air gap
* PEEK-material tube holder mount
    * Mounted to heatsink with two M2.5-0.4x10 hex-head screws (2mm hex)
* PTFE tube into hotend
    * Supposedly 32mm long when new. PTFE tubes are known to shrink with high print temperatures
* Hotend tube with heatsink shroud, down to nozzle chamber
* Copper nozzle gasket
* Nozzle
    * 12mm retaining nut with 2.5?mm hole in center
    * Maaayyyybe enough room at the top of the threads for a temp sensor closer to the nozzle tip?

#### Motor and gear

The Cetus2 V2 extruder is a direct drive extruder with the filament gripping gear located just above the hotend PTFE tubing. 

* FY-Motor 25BYHJ49-24B
    * No [exact match on their website](http://en.fy-motor.com/product/148.html) but similar models indicate:
    * Step angle: 7.5 degrees
    * 2 phases, 2 wires for each phase.
    * 12V 0.3A (constant current?) 20Ω 9.8mH
    * "Step avail": 1/47.32mm ?
    * Push torque: 900N
    * Shaft: 5mm x 13mm-ish

The geared stepper motor is sandwiched against the black metal frame, then a white delrin? injection moulded part acts as the guideway for the filament. The bearing and e clip does not need to be removed to take off the delrin, it's just the two bolts holding it in.

The stock gear appears to be fairly rough machined steel of some sort, it's uncomfortably rough against my fingers and doesn't feature a tooth profile you'd expect for an actual gear. This implies it's custom stock for this purpose.

The stock gear is press-fit onto the motor shaft, including a flat spot on the shaft and a D-shaped inner diameter on the gear. The gear is a nonstandard 9mm-ish sandwiched between two 10mm bearings, appear to be C5-10ZZ (5mm ID, 10mm OD, 4mm thick, double shielded).

A second smaller bearing is used to direct the filament against the gear. It's press-fit into the white delrin guide, appears to be a 683ZZ (3mm ID, 7mm OD, 3mm thick, probably double shielded). There is no spring for additional clamping load.

This gear in the past has been [identified as having quality control issues](https://www.cnckitchen.com/blog/fixing-inconsistent-extrusions-systematically) and an off-center bore. This can lead to patterns and inconsistencies in extruder flow, especially on larger complex parts. If you've excluded other common troubleshooting steps this may be something else to check. I haven't dialed in the rest of my machine well enough to identify this issue yet.

#### Bracket pieces

Instead of left/right I identify the parts by the filament number they're attached to. The parts have mirror symmetry, not rotational, so keep them straight. I marked them with a marker.

* Extruder motor bracket (2x)
    * Each bracket mounted to the heatsink block below it with two M3-0.4?x8 hex-head screws (2.5mm hex key)
* Heatsink block (2x)
    * Same threaded holes on both parts for part cooling fan, only used by one fan.
    * Heatsink clamps to the hotend element with a clamp screw behind the mount, looks to be an M3 screw?
* PEEK PTFE tube holder (2x)
    * Mounted to heatsink with two MX-0.4-XX hex-head screws (2mm hex)
* Hotend fan deflector (1x)
    * Structural, holds the heatsinks in alignment.
    * Mounted to each heat sink with two M3-0.4x6 hex-head screws (2.5mm hex key)
* Extruder head printer mount (1x)
    * Structural, holds the heatsinks in alignment.
    * Mounted to each heat sink with two M3-0.3?x8 hex-had screw (2.5mm hex key)
    * Mounted to the gantry platform with one (!) M4-0.8x10 hex-head screw (3mm hex) with a lock washer and a washer.

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
