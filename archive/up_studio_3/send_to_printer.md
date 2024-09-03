# Sending a print to the printer

Instead of juggling SD cards you can send a print directly to the printer from UP Studio3. 

This is great for rapid iteration when dialing in the printer.

Ask me how I know.

## Connections and setup

### Prepare the printer

1. Connect your printer to wifi.
2. Install a known working SD card with a good amount of space on it.

Connect your printer to wifi via whatever you need to do. For my Cetus2 this was through the touchscreen interface. Pro tip, use the end of one of the included allen wrenches as a stylus to tap out the wifi password.

You should make sure your SD card works and can be read by the printer. For my Cetus2 I'm using a FAT formatted 8gb card, Class 10 (U1) speed. Two other SD cards I tried did not work. I loaded a test print file onto one and made sure it print cleanly.

### Prepare UP Studio3

1. Connect to the printer via Wand.

Wand is a second utility that runs alongside UP Studio3. It should start automatically when you open UP Studio3, apparently on MacOS it's a separate install.

If you can't find Wand you can start it by clicking on the printer selector and clicking 'Manage Printers' at the bottom. I've found the Wand utility tends to be more crashy than the studio, sometimes I have to restart Wand after it crashes through this menu too.

![image](https://user-images.githubusercontent.com/1441553/215442980-54005574-5a1b-4839-bd0b-41442e49d75f.png)

Connect to your printer via Wand. Once connected it should show a little status screen with a few buttons, such as moving the printer up and down and adjusting the loaded materials.

![image](https://user-images.githubusercontent.com/1441553/215445728-686cd71c-b56f-4422-bf5c-0cc03b17f96c.png)

2. Select your printer in UP Studio

Once Wand is connected to your printer you can select the printer in the studio. Click the printer selection dialog AND WAIT FIVE TO TEN SECONDS. Seriously, every time you need to interact with selecting your printer you will need to wait multiple seconds for it to 'refresh'.

Your printer will be displayed by its serial number (which is why it's blurred in my screenshots). Select it to make it your active printer.

Once this is all set up you can configure your printer and send prints.

## Sending a print

1. Load in the model you want to print
2. Set the appropriate settings you want, such as layer thickness and print speed.
3. Slice the model.
4. Select the sliced model.
5. Click the print button.
6. Click print.

![image](https://user-images.githubusercontent.com/1441553/215444256-26c9b702-090f-4de0-bde1-8ca2fa3af4c9.png)

## Troubleshooting

### Wand lost connection

This happens so often. Oh my goodness so often.

For a variety of errors Wand will lose the plot and disconnect. The 'auto-reconnect' setting doesn't appear to be working, so expect to jump in and manually reconnect. Often. I've also had it lock up and crash multiple times, after which I need to restart Wand and then reconnect.

### UP Studio lost the printer

If Wand disconnects in a particularly violent way UP Studio will silently drop the selected printer. Reconnect in Wand then re-select the printer.

### File not found when sending a print

Your SD card isn't working. Make sure it's there and working correctly.

When you send a print over the network to the printer it actually does a file transfer to the SD card. It will then read the print off the SD card while printing, so your computer can lose connection and it'll be okay.

### Wand crashes partway through sending and the printer goes nuts

My Cetus2 doesn't seem to like interrupted file transfers. It'll attempt to print a clearly invalid file and this hoses the firmware. I reboot the printer when this happens.

### Changing settings in Wand causes it to disconnect

Changing things like the material type, nozzle size, etc. seems to take a VERY LONG TIME to happen over the network. Wand will sometimes time out when this happens, and sometimes it'll self-recover. 

Do one change at a time and wait for Wand to update its interface. Do everything slowly and you'll have a higher chance of success.
