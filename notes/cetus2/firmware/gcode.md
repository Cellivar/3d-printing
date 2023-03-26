# Cetus2 Firmware g-code notes

The Cetus2, like all Tiertime printers it seems, has a custom interpreter for g-code. 

## Official Support

According to the kickstarter, official support for other g-clode is coming eventually. 

For now, there's only this older document: https://support.tiertime.com/hc/en-us/articles/360001465934-Printing-with-Gcodes

That doc lists these commands:

* G0: linear Move
* G1: fast linear move
* G4: Dwell
* G28: Move to Origin (Home)
* G90: Set to Absolute Positioning
* G91: Set to Relative Positioning
* G92: Set Position, only support A axis reset.
* M0: Stop or Unconditional stop
* M1: Sleep or Conditional stop
* M2: Program End
* M25: Pause SD print
* M42: Switch I/O pin
* M73: Set build percentage
* M80: ATX Power On
* M81: ATX Power Off
* M82: Set extruder to absolute mode
* M83: Set extruder to relative mode
* M92: Set axis_steps_per_unit
* M104: Set Extruder Temperature
* M109: Set Extruder Temperature and Wait, Example M109 S215
* M140: Set Bed Temperature (Fast)
* M141: Set Chamber Temperature (Fast)
* M190: Wait for bed temperature to reach target temp
* M191: Wait for chamber temperature to reach target temp
* M204: Set default acceleration
* M206: Offset axes

## Converters from standard g-code

The command code interpreted by the printer is not directly compatible with other slicers, and as a result requires a translation layer.

These are random projects I have found out there and have no idea if they work. More research needed.

* https://github.com/UP3D-gcode/UP3D
* https://www.stohn.de/3d/index.php/2016/03/03/up-mini-g-code-transcoder-part3/
* https://forum.tiertime.com/t/simplify3d-profile/472
* https://forum.tiertime.com/t/config-for-cetus3d-mkii-in-slic3r/1007
* https://forum.tiertime.com/t/howto-cura-w-cetus3d/824
* 

## Discovered notes

### G9 Command

The Cetus2 firmware has special handling for the G9 command that appears to alter how the retraction mechanism works. The "special configuration" package used as part of first-time setup includes this line:

`DEF G9 SET V220 V23, SET V23 3, G0 E-30,G9 X{X} Y{Y} Z{Z} H{H},G0 E30, SET V23 V220`

I haven't had time to dissect what this exactly means. It appears to be a custom setup for the G9 command to perform other operations.

The "normal" G9 command is interpreted as a "move to position and come to a complete stop", and is used in CNC machines for fine detail control. That doesn't appear to be what's going on here.

[Dan from KautzCraft](https://dimensionalprint.kautzcraft.studio/fdm-fused-deposition-modeling/cetus2/78-secret-code-in-cetus2) learned that this radically altered stringing behavior on their Cetus2 preproduction unit.

