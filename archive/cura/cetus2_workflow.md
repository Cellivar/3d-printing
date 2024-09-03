# Cetus2 Cura Workflow

This is the process to go from a file in Cura to printing on the Cetus2 Printer, as of May 2023. This workflow comes from [their release video](https://www.youtube.com/watch?v=PSJX1s5Jaj8).

## Export Workflow

Because the Cetus2 uses a proprietary communication protocol Cura can't talk to the printer or to the Want software directly. Instead we must export the GCode file directly.

1. Prepare your model for printing how you see fit.
2. Click the 'Slice' button in the bottom right to slice the model.
3. File -> Export.
4. Open the file type dropdown and select G-Code file.
5. Move the G-Code file to an SD card inserted into your computer.
6. Safely eject the drive, then insert the card into the printer.
7. Use the printer menu to start the print.

At time of writing Cura cannot communicate directly with the printer.
