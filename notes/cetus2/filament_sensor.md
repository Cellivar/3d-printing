# Tiertime Fillament Use Sensor

Included in the Deluxe model and available for separate purchase otherwise is the fillament sensor unit, a module that screws onto the back of the printer.

The internal board contains a microswitch to detect filament out/breaks and a rotating head with magnets to track filament use.

Two LEDs signal the filament status for each channel, though they're so far into the case they can sometimes be hard to see.

## Electrical

6 pin JST-alike connector

1. +5v? (4.9 measured)
2. Pin 5 on U2 (P3.0, according to the datasheet)
3. Can't trace easily, probably some kind of communication
4. Ground
5. Empty on included wire
6. Empty on included wire

Microcontroller: `STC 15L104W`
Hall effect sensor: `HM6207`

Pins 5 and 6 are not on the cable for my printer, and go to a single resistor that is measuring ~78kOhms. My speculation is this was an early 'detect sensor connected' wire that was abandoned. This may get revisoned out in the future, or repurposed as some kind of DRM.

## Physical

The filament goes up through the unit, past the flow sensors, then activating the microswitches.

The system is attached to the back of the frame with M3-0.4x35 phillips screws.

![image](https://user-images.githubusercontent.com/1441553/216914368-29e942aa-1037-4f0b-9800-870fadd2dc4b.png)


## Modification

I modified my printer by moving the sensor up about 7cm along the back of the frame. I found the lower height of the sensor conflicted with my filament drybox setup, and the stock bowden tubes from the sensor to the extruder head would occasionally result in bad calibration passes.

I stopped by my local Ace Hardware to pick up the screws I needed and just drilled the holes myself with a cordless drill. Take care to make sure metal shavings don't fall into the machine to eventually give you mysterious problems later on.

After this modification I had better extruder performance and fewer spurious autocalibration passes.

![image](https://user-images.githubusercontent.com/1441553/216914847-631ba794-f9df-4e31-aea0-4f6619d2e088.png)
