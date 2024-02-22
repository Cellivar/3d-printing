# Linear Bearing Lubrication

LINEAR BEARINGS DO NOT RUN DRY. WHOMEVER TOLD YOU THAT IS INCORRECT. USE LUBE.

[The authority is this manual by HIWIN](https://www.hiwin.com/wp-content/uploads/lubricating_instructions.pdf). They know what they're doing. This guide is distilled from the manual.

## I don't want to read this what lube do I use

If your manufacturer gave you instructions follow those instructions. They probably know what they're doing or they at least copy/pasted the instructions from their linear bearing supplier.

Otherwise, read on.

### Less than 750mm/s speeds (nearly all printers)

* (NLGI Grades 0 through 2 are fine)
* Mobilux EP0, EP1, EP2
* HIWIN G04, G05
* Klüberlub DL-261
* Lagermeister BF2
* TURMOGREASE CAK 2502

### More than 750mm/s speeds

* (NLGI Grade 0 or Grade 00)
* Mobilux EP004 Grease
* Isoflex Topas NCA5051
* GEARMASTER LI 400
* HIWIN G06

Or oils:

* Mobilgear 630 Oil
* GEARMASTER CLP 320 Oil
* Klüberoil GEM 1-150 N

## Theory of operation

A linear bearing is a sandwich of a metal plate, a bunch of little metal ball bearings, and another metal plate. The balls all roll along, facilitating the two metal plates to slide past each other.

The critical piece here is that _rolling_ action, it must roll to operate correctly. A ball bearing that is not _rolling_ is instead _being ground in one spot against a piece of metal_. It ceases to be a bearing and becomes a sacrificial part, getting worn down faster over time until you're buying a new expensive rail and carriage.

The carriage is, usually, shorter than the length of the rail. The ball bearings need to go somewhere when they roll to the end of the carriage, so they get _recirculated_ through a channel in the end caps backwards to the other end of the carriage. There they start carrying the load again as they roll. This is why they're called _linear recirculating bearings_.

The circulation of ball bearings through the carriage is important: it distributes lubricant and wear. If the carriage doesn't move far enough that the balls can completely recirculate it's considered to be a _short-stroke_ application. The carriage must move 2 times its length for the balls to completely recirculate, less than that is a short-stroke. Printers, especially small ones, may spend a lot of time performing short-stroke movements.

With that in mind the goal is to provide lubrication to the ball bearings such that they continue to roll, but can roll with as little friction as necessary to accomplish that rolling.

## Types of Lube

For our purposes 3D printers are "low load" devices, focusing on type of movement instead of amount of weight being moved. This lets us deal with two categories of lube: grease and oil.

[Greases have an NLGI Grade rating](https://www.nlgi.org/grease-glossary/nlgi-grade/) which is [how thick](https://www.youtube.com/watch?v=OPSCjnwD3gc) the grease is. Higher is thicker. 3D printers don't operate in extreme conditions and linear bearings don't need to work grease in. NLGI grades 0 to 2 are fine.

If you are doing _very fast_ prints, defined as travel speeds approaching 1000mm/s, you may consider the use of oil instead of grease. Oil collects dirt faster, spreads out of the carriage faster, and must be reapplied faster. It can result in better behavior with short-strokes and higher speeds as it gets distributed onto the rail more evenly.

Not all lubricating oils are created the same, you'll want to ensure you get ones compatible with your linear bearings.

### Lube NOT to use

* Anything with solid particles of stuff in it. These are designed for sliding action such as gears or bushings, NOT for linear bearings. These will accelerate wear.
  * PTFE chunks (Superlube)
  * Molybdenum disulfide grease (MDB, MoS2, "moly", etc.)
  * Graphite
* Grease with an operating temperature lower than your chamber temperature. 80C grease will not be happy in 120C chamber printing polycarbonate. Grease will start to separate and stop being a grease above its rated temp.

### Switching Lubes

Individual linear rails often ship with a protective coating of oil and no service lubrication. If you're using grease you can leave it and just apply your grease. if you want to use oil you must remove the protective oil first by soaking the rail and carriage in isopropyl alcohol. Move the carriage from end to end multiple times to ensure proper cleaning. Apply grease after it dries completely.

If you want to switch from grease to oil you must remove all old grease from the carriage. Don't lose any ball bearings. Good luck.

Switching from Oil to Grease is fine, just grease it up.

Switching NLGI grades of grease can differ by single step (such as from 2 to 1) but no further without a full cleanout of the old grease. If the base oil type of the grease differs it also must be cleaned out first, they won't mix and won't lubricate properly.

### 3D Printing Operational Characteristics

3D printers have these operational characteristics:

* Less than 1000mm/s travel speed.
* Low load ratio.
* Lots of short-stroke movements.

## When to lube

Generally, you add lube when you need to add lube. The maintenance schedule is driven by how hard you use the rails. 3D printers aren't very heavy, so the wear mostly comes from contamination of dust and filament junk that lands on the rails and the speed the printer is operated at. The harder you run things the shorter your maintenance interval.

Grease ages slowly and stays put. Oil ages quickly and oozes out. A printer using oil and left alone for a few weeks should get some additional oil the next time you use it

Pre-assembled printers tend to be lubed up and ready to go.

Kits may have special instructions to follow.

Rails purchased on their own usually do not have any lube, you must add some.

As a general rule of thumb your rails should have a very thin layer of grease on them from the carriage moving across the rail. If this is missing you probably need to re-apply.

A good rule of thumb is every 150km of travel along the rail.

### How to lube

The goal is to provide enough lube for the ball bearings to roll.

You will need a syringe, you can get them cheap from a drugstore. Thicker needles are preferred.

On either end of the carriage there will be a small hole in the center. See the manual for images. You may ned to remove a cover screw. This is the grease port where you add lube.

If you can't find one (or your cheap carriage doesn't have one) you [will need to follow the flip and pack method](https://docs.ldomotors.com/en/guides/rail_grease_guide) from LDO motors. In short, you center the carriage over a hole in the rail and slam grease into the rail. Go until it just barely oozes out the ends. Work the carriage back and forth a bunch to distribute.

1. Put your grease into your syringe.
2. Check the table below (or in the manual linked at the top) for the amounts to apply.
3. Stick the end of the syringe into the grease port and add the specified dose of lube.
4. Move the block three times by about three block lengths twice.
5. For initial lubrication repeat steps 3 and 4 twice, for a total of 3 doses of lube.
6. Carefully look at the rail and see if there's a thin film of lubricant where the carriage moved. If not, add a bit more lube and repeat step 4.

### Lube Quantity (in cm^3)

| Carriage Size | Initial Lube | Relube |
| ------------- | ------------ | ------ |
| MGN07         | 0.01         | 0.01   |
| MGN09         | 0.02         | 0.02   |
| MGN12         | 0.03         | 0.04   |
| MGN15         | 0.04         | 0.07   |
| MGW07         | 0.01         | 0.01   |
| MGW09         | 0.02         | 0.02   |
| MGW12         | 0.04         | 0.04   |
| MGW15         | 0.07         | 0.07   |
