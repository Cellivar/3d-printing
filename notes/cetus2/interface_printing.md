# Printer interface during printing

The printer has a limited interface during printing that lets you tweak settings on the fly to correct printing problems.

## Print Progress Menu

The default menu shows the current print progress, with two buttons for pause and settings.

The print progress timer doesn't match reality, and it wil sometimes 'catch up' depending on how the print is going. Notably it'll continue counting down while paused.

## Print Settings

Tapping the gear button will bring you to the print settings menu. The interface is laggy, wait until a change happens before tapping multiple times.

![image](https://user-images.githubusercontent.com/1441553/218245197-3ae50160-4d70-4814-8871-60bdb8079732.png)

### Speed control

The speed control is straightforward: up for faster, down for slower. The speed change can take a few gcode instructions to take effect, listen for the change in stepper motor noise to know when it kicked in if you're using it to chase down problems.

### Ratio control

I don't know what this does. 

### Mat1 and Mat2 control

The buttons on the right control the extruder temperature offset. Up will increase the temperature above the default value, down will decrease it. This can be handy for small tweaks during a print.

### Up/Down Buttons

I don't know what these do.

## Print Pause menu

Tapping the pause button will cause the extruder to pause after its next gcode instruction is complete and pull away from the print bed.

You can use the pause menu to unload and swap materials in the extruder before proceeding. In my experience the extruder will always cause a vertical bead of filament that needs to be cut off before continuing with the print.

