# PETG Printing Notes for the Cetus2

These are general notes that have resulted in more consistent positive results from printing PETG.

## General Conditions

My printer is in a downstairs garage in the Bay Area of California. Ambient temperature hovers around 65F, which is annoyingly low for PETG printing. It's a rental and vented to the atmosphere. Eventually I'll construct an enclosure, until then I deal with this temperature range.

To avoid issues with drafts I place a piece of cardboard around the printer. This helps to avoid ambient drafts messing with print quality. It's no substitute for a heated enclosure.

### Let the bed heat soak

The heated bed struggles to get up to 90C-ish which is where I stopped having severe warping issues. Remember also that the print bed temperature sensor is mounted below the steel surface and the printer is printing on top of the glass. It can take upwards of an hour to properly let the bed heat soak up to temperature.

The printer firmware has a safety timeout on the heated bed which means it will get to about 60C and then turn the bed heat off unless you babysit it. I keep the Wand tool open on my computer while I wait and occasionally toggle the bed heat off and back on to reset the timeout. This isn't annoying at all, especially when you get distracted and lose a fair amount of heat from the system.

I am investigating ways to improve this.

### Surface prep is key

PETG demands a clean surface with some kind of release agent. I didn't believe this at first and printed directly on the stock glass bed directly. My first print came out great, my second print stuck HARD. Took waiting for the bed to get stone cold and then lots of prying/force to slowly work it loose.

My second approach was to use a glue stick. One was provided with my printer and I used that on top of the stock glass sheet for a while. It works well, however quickly gunks up due to the print heat. I found that I needed to keep moving new prints around the bed or else I'd have to clean it with soap and water, make sure it was completely dry, clean it with IPA, then re-apply glue.

I purchased a textured PEI sheet with magnetic mount. The magnetic surface uses adhesive to stick to the print bed, then the PEI sheet is backed with spring steel and magnetically attaches to the bed. I clean this with IPA, then wipe it down with Windex (the real stuff) to prepare the surface. With this combination I have had fewer issues with warping, and when prints are complete they usually pop right off of the bed. Occasionally I have to lift the bed off of the magnetic base and warp the spring steel to get it to cool down and release.

## Material Profile

UP Studio3 material profile settings that the rest of the tuning happened around.

| Setting       | Value    | Notes                                                                                             |
| ------------- | -------- | ------------------------------------------------------------------------------------------------- |
| Type          | PETG     |                                                                                                   |
| Manufacturer  | Overture | [Amazon](https://www.amazon.com/OVERTURE-Filament-Consumables-Dimensional-Accuracy/dp/B07PGYHYV8) |
| Diameter      | 1.75     | Factors into extrusion rate which is tuned elsewhere instead of messing with this                 |
| Density       | 1.27     | Seems to just affect estimates                                                                    |
| Speed Ratio   | 1.00     | Factors into print speeds. I don't fully trust this setting and tuned elsewhere.                  |
| Raft Speed    | 15       | I don't use rafts so didn't test this.                                                            |
| Retract speed | 200      |                                                                                                   |
| Max Length    | 20.00    |                                                                                                   |
| Min Travel    | 2.50     |                                                                                                   |
| Ratio         | 6.00     |                                                                                                   |
| Print Temp    | 230      |                                                                                                   |
| Standby Temp  | 220      |                                                                                                   |
| Platform      | 100      | It usually hovers around 92                                                                       |
| Shrink X      | 0.10     |                                                                                                   |
| Shrink Y      | 0.10     |                                                                                                   |
| Shrink Z      | 0.10     |                                                                                                   |

## Main settings tuning

These settings are generally set once for PETG and not modified again. I keep a separate primary configuration for PETG to help with this.

### Printer tab

* Change the Print Cooling command down to `M42 P14 S150`. The S150 sets the fan to ~30% which results in better layer adhesion than full cooling fan.

### Extruder tab

I did not find adjusting the scale factor to be a useful setting to modify, it changes too many things at once and makes it harder to figure out where it helped or hurt. I would fix one problem and then run into another problem by changing this. It's set back to 1.00.

## Per-print tuning

I often tweak other settings on a per-model basis.

### Slice

I will often slightly adjust path width to ensure good adhesion of the internal pieces of my parts, especially PETG parts that need strength. Slightly adjusting them wider or thinner doesn't severely affect print quality.

* I do not use purge towers.
* I do not use a raft.
* I try to avoid upports wherever possible. When I do need to use supports it's very sparingly and carefully designed using the support designer.

### Path

* 1 outside perimeter, 2 if I really really want it to be pretty or something.
* Infill perimeters: Always.

This results in a minimum of 2 perimeters: an "outside" and "infill perimeter". UP Studio3 seems to arrange these slightly closer together than multiple outer perimeters and I have had fewer issues with inner and outside perimeters failing to adhere this way.

When printing circular parts I will sometimes adjust the infill path to settings other than ZigZag. Try the other settings and see the slicer preview to get an idea of how it will print, sometimes this can be advantageous.

### Special

I print with two spools of PETG for speed purposes, so my Print Extruder settings are all set to Extruder 3. This uses both spools in a 50/50 ratio.

### Print

SLOW IT DOWN. I had _endless_ underextrusion problems until I just cranked the speed down across the board. This involved a lot of trial and error printing long straight patterns and listening for clicking from the filament extrusion motors. Once I dialed the temperature in to 230 I listened for clicking and adjusted the print speed on the printer's touchscreen until the clicking stopped and it extruded cleanly. I then adjusted the speed values accordingly.

The default "Normal" speed table is a little too fast, it worked okay for finer details but did not work well for larger prints. The "Fine" speed table worked consistently. I have since created PETG variants of these speed tables for fine details or draft prints.

* Temperature tune: 0

Temperature tweaks here didn't really help. The nozzle doesn't respond to temperature changes fast enough to be useful here.

* Z-Hop: 1.00

Setting Z-Hop crazy high like this means it's more likely to clear obstacles like mild warping in corners. This turned a large number of "definitely getting knocked loose" prints into "warped but still usable for their purpose" prints. The z-axis on the Cetus2 is lightning fast compared to other printers so even a 10x increase in this setting didn't result in a big speed penalty.

* Extrude scale: All defaults

Once the temperature and speed are accounted for I did not find tweaking the extrusion scale to be particularly useful here. I tried chasing these values when I was having underextrusion issues caused by problems I now believe were caused by something else.

* Seam optimization

This is entirely cosmetic and up to you to tweak to your heart's content.

* Speed reduction

First layer speed is dropped to 50%. Because UP Studio3 doesn't have a first layer offset setting it often will ram the PETG into the print bed and PETG doesn't really like this. By speeding things WAY down it seems to gives the material time to ooze out to the sides of the nozzle. This improves bed adhesion (higher percentages were VERY sensitive to SMALL bed levelling issues) and bottom layer quality.

Oddly, messing with the first layer feed just caused problems, this is at 100% for me.

* Print cooling: yes!

This printer does not like printing PETG with zero cooling, test prints came out a blobby mess with a lot of smearing from the nozzle. A _low_ print cooling fan speed helped a lot though, see the section above about the Printer tab settings.
