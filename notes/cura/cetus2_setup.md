# Cetus 2 Profile Setup

Tiertime released their [Cetus2 setup guide via a YouTube video](https://www.youtube.com/watch?v=PSJX1s5Jaj8) and [an accompanying guide](https://support.tiertime.com/hc/en-us/articles/18541622274457-Use-Cura-to-Slice-for-Cetus2).

For the day-to-day use workflow see [cetus2_workflow.md](./cetus2_workflow.md).

## Cura Profile 2023-04-17

This was the first profile they released. The initial release of firmware 1038 had issues and was supplemented with 1038-2 to fix them.

The setup guide is as follows:

1. [Download and update the printer to firmware 1038-2 at least](https://www.cetus3d.com/software/).
2. [Download and install Cura, at least version 5.3](https://ultimaker.com/software/ultimaker-cura/).
3. If you're running Cura for the first time you will go through printer setup immediately.
    * If this is not your first time, open the Add a Printer screen with Settings -> Printer -> Add Printer
4. Expand the 'Add a non-networked printer' screen, select 'Custom', then 'Custom FFF printer'.
5. Update the printer name to something better, like `Cetus2`.
6. Hit Next.
7. You will be presented with a bunch of printer settings, which are detailed in the table below. Fill them out. Be sure to include the 'Extruder' tabs.
8. Complete the Cura setup.
9. Install the plugins. You can use these links if you have an account, or click the 'Marketplace' button in the top right of the main Cura screen and use the search.
    * I found the search to be broken, search instead for `fieldofview` to find these.
    * [Install this Printer Settings plugin](https://marketplace.ultimaker.com/app/cura/plugins/fieldofview/PrinterSettingsPlugin)
    * [Install this Z Offset Setting plugin](https://marketplace.ultimaker.com/app/cura/plugins/fieldofview/ZOffsetPlugin)
10. Restart to load the plugins.
11. Settings -> Printer -> Manage -> Profiles -> Import, selecting the downloaded Cura profile file from Tiertime.
    * You should see a success message. Click OK.
12. Close the settings window.
13. Extensions -> Post Processing -> Modfy GCode.
14. Add the LAYER0 > LAYER1 rule
    a. Click `Add Script`
    b. Click `Search and Replace`
    c. Enter Search: `;LAYER:0`
    d. Enter Replace: `;LAYER:1`
    e. Ensure 'Use Regular Expressions' is unchecked.
15. Add the LAYER -> M73 L rule
    a. Click `Add Script`
    b. Click `Search and Replace`
    c. Enter Search: `;LAYER:`
    d. Enter Replace: `M73 L`
    e. Ensure 'Use Regular Expressions' is unchecked.
16. Close the Modify GCode window.
17. On the main window click the dropdown for the Printer Settings.
18. Click 'Show Custom'
19. Search for `Diameter`
20. Under Printer Settings, set the `Diameter` to 0.4 (yet this is their official instruction..)
21. Search for `Z offset`
22. Under 'Build Plate Adhesion' set `Z Offset` to -0.2 and enable `Extensive Z Offset Processing`.

Note: The -0.2 Z Offset value includes a note "this value needs to be determined by test print". The video suggests -0.4. At time of writing I have not tested these values.

### Printer Settings

| Printer Settings    | Value         | Printhead Settings              | Value         |
| ------------------- | ------------- | ------------------------------- | ------------- |
| X (Width)           | 200           | X min                           | 0             |
| Y (Depth)           | 300           | Y min                           | 0             |
| Z (Height)          | 300           | X max                           | 60            |
| Build plate shape   | Rectangular   | Y max                           | 80            |
| Origin at center    | No (blank)    | Gantry Height                   | 80.0          |
| Heated Bed          | Yes (checked) | Number of extruders             | 5             |
| Heated build volume | No (blank)    | Apply extruder offsets to GCode | Yes (checked) |
| G-code Flavor       | Marlin        |                                 |               |

| Extruder Setting      | Value                                          |
| --------------------- | ---------------------------------------------- |
| Nozzle Size           | 0.4 (or 0.6 if that's the nozzle you're using) |
| Material diameter     | 1.74                                           |
| Nozzle offset X       | 0                                              |
| Nozzle offset Y       | 0                                              |
| Cooling fan number    | 0                                              |
| Extruder Start G-Code | _Blank_                                        |
| Extruder Stop G-Code  | _Blank_                                        |

### Printer Start G-Code

```text
;{"ver":"100","model":"Cura","printer":"Cetus2","mat":"PLA","thick":"20","fill":"0","time":"18","weight":"29"}
;Job Name: Z
;User Name: g
M83; A axix relative
DEF G10 G0 A-30 B-30
DEF G11 G0 A30 B30
M104 T0 S210; adjust temp (S value) for different material
M104 T1 S210; adjust temp (S value) for different material
PROM 2
M42 P14 S511; open cooling fan
```

### Printer End G-Code

```text
G92.9 X0 Y0
T0
PROM 5
M2
```
