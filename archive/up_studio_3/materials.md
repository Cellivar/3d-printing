# Materials in UP Studio 3

The materials editor is somewhat counterintuitive in UP Studio 3. The materials configuration needs to first be created and then assigned to the appropriate extruders in the config menus. This is a multi-step process

The materials configuration is stored as part of the primary configuration, not separately, so if you have multiple primary configurations for multiple printers you will need to re-configure your materials each time.

## Expert view

1. Open the preferences menu and enabled 'Advanced UI', otherwise you can't see these settings.
2. Click on the large gear icon to edit the primary configuration.
3. Click on the configuration expertiese level button (defaults to 'basic') until it says 'expert'.

You can now see the 'Material' tab and modify the settings appropriately.

![image](https://user-images.githubusercontent.com/1441553/215379988-4d66c93d-4248-4de8-99f5-93bf81bcf1fe.png)

## Material configuration

The Material tab controls the list of available filament materials. 

Out of the box Tiertime provides default configurations for several common materials. These work well enough to get started, but they have special rules that appear to prevent editing of settings outside of the defaults.

When you want to modify your own configurations you will need to create a new material profile to edit.

1. Click the + icon to the right of the Filament list.
2. Input a name that will clearly distinguish the filament type
    * For example, I use `PLA-Hatchbox` for my dialed-in Hatchbox material configuration.
3. Copy the default material profile that matches the actual material you're setting up, this copies all of the settings into the new profile as a starting point.

Once you have created the new material configuration you can edit the settings as needed.

### Available materials settings

Instead of allowing you to provide specific values for various things a lot of Tiertime's software only allows you to provide inputs for an algorithm. Where possible these concepts are explained in their documentation, though sometimes it can be unclear.

* Fillament - This is the material configuration you're editing.
    * Type - The general type. Has unknown effect when changing this value, may just be for show.
    * Material ID - Unique ID for each material configuration generated. Cannot be edited.
    * Manufacturer - Freetext field, just used for display and has no effect.
    * Filament Diameter (mm) - The diameter of the filament. Input into the extrusion rate algorithm.
    * Density - (g/cm3) Density of the material, used for filament consumption estimation.
    * Cost/Kg - Freetext field, just used for display and has no effect.
* Print
    * Speed ratio - Multiplier applied to all field speeds involving printing. Can set this lower if you have a spool of particularly tricky material, for instance.
    * Max Raft Speed - Maximum allowed speed the first layer _of rafts only_ that the slicer will clamp to. Faster speeds set elsewhere will be overridden by this value.
* Retract - (See article on retraction settings)
    * Speed - (mm/s) The speed at which the motor will retract filament. Faster is harder on the motor, slower may cause more stringing. Adjust temperature before adjusting this.
    * Max length (mm) - Unclear. "Max possible length for a single retraction", perhaps the high limit for the retracton calculation?
    * Min travel (mm) - The minimum distance the head must need to jump to engage retraction. If the head needs to cross a gap smaller than this size it won't bother with retraction.
    * Ratio - Ratio * travel length = actual retraction. 
* Temperature
    * Print (C) - Extrusion nozzle temperature.
    * Standby (C) - Temperature to let the nozzle drop to when idle during multi-extrusion printing.
    * Platform (C) - Temperature to set the heated bed to.
* Shrink - Compensation percentage for material shrinkage after cooling. Input into the extrusion rate algorithm.

## Extruder material assignment

Once you have set up your material you can assign the material to an extruder.

You can either use the buttons at the top of the screen...

![image](https://user-images.githubusercontent.com/1441553/215382305-1047bb33-3ca0-4dfd-9e65-756620c69ba5.png)

... or the extruder tab in the configuration.

![image](https://user-images.githubusercontent.com/1441553/215382265-86606ef9-cfc2-4701-aefe-a17d0031b140.png)

### No matching parameters

![image](https://user-images.githubusercontent.com/1441553/215382709-3ddd3a9e-2719-493d-9f7f-3def0759a903.png)

When you create a custom material and assign it to an extruder you'll get a warning about 'no matching material'. UP Studio3 appears to have hardcoded support for the default materials. This warning seems to be more like "Using a non-default material, hope you know what you're doing!"

## Load to Printer

Once you have your new material configured you need to send it to the printer.

1. Make sure your printer is conneced in Wand.
2. Back in Up Studio3 Click the printer selection dropdown and wait 5 seconds for your printer to show up.
3. Select your printer, this will set it as the active printer.

While a real printer is connected as the active printer you can now select your new material in the material drop-down at the top of the screen. EVERY TIME YOU DO THIS THE WAND APPLICATION WILL LOCK UP FOR UP TO 10 SECONDS. If you try to do anything else while it's locked up it will crash and you'll have to start over.

When you select your new material for extruder 1 in Up Studio3 switch back to the Wand application and watch it disconnect and then reconnect. When it reconnects (either automatically or manually) it should show your material in the extruder 1 slot. Repeat the process for extruder 2.

This is the fastest and most reliable way I've found to modify my material profiles.

### Updating an existing material

When you change an existing material you need to force Up Studio3 to update the material on the printer.

1. Ensure your printer is connected in Up Studio3
2. Select a different material for extruder 1 than your modified material. 
3. Wait for the Wand appliation to reconnect. Do not do anything else until it's reconnected.
4. Once reconnected selec a different material for extruder 2. Wait for Wand to disconnect and reconnect. (Yes really.)
5. Now that the printer has a different material selected for both extruders you can push your updated material to the printer.
6. Select your updated material for extruder 1. Wait for Wand to reconnect.
7. Select your updated material for extruder 2. Wait for Wand to reconnect.
8. Slice and print your model.
