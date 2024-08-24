#FROM ubuntu:21.04
FROM alpine:latest

# Install xorg server and related packges
RUN <<EOF
apk update --no-cache
apk add --no-cache dbus eudev mesa-dri-gallium mesa-egl xf86-input-libinput xf86-video-fbdev xinit xorg-server xrandr xset
EOF

# Install UI apps
RUN <<EOF
apk update --no-cache
apk add --no-cache chromium unclutter-xfixes openbox xeyes xclock
EOF

# Generate entrypoint script
COPY <<EOF /usr/bin/entrypoint.sh
#!/bin/sh
/usr/bin/xinit /usr/bin/chrome.sh -- :0 -nolisten tcp vt1
EOF
RUN chmod +x /usr/bin/entrypoint.sh

# Generate startup script for chrome
COPY <<EOF /usr/bin/chrome.sh
# #!/bin/sh

# Hide mouse cursor on touch input
unclutter-xfixes --hide-on-touch &

# Start the window manager
openbox

# Temp: Run xclock to see if the screen is working..
xclock -update 1 -d

# TODO: Chromium throws an absolute fit trying to start up. Debug or switch?
# Give up and use Klipperscreen?
# chromium-browser $START_PAGE \
#   --window-size=400,1280 \
#   --window-position=0,0 \
#   --start-fullscreen \
#   --kiosk \
#   --incognito \
#   --noerrdialogs \
#   --no-first-run \
#   --no-default-browser-check \
#   --disable-back-forward-cache \
#   --fast \
#   --fast-start \
#   --disable-infobars \
#   --disable-features=TranslateUI \
#   --disk-cache-dir=/dev/null \
#   --overscroll-history-navigation=0 \
#   --disable-pinch

# if [ "$#" -eq 0 ] ; then
#     /usr/bin/X :0 -nolisten tcp vt1
# else
#     echo "$@" > /usr/bin/entrypoint-command.sh
#     chmod +x /usr/bin/entrypoint-command.sh
#     /usr/bin/xinit /usr/bin/entrypoint-command.sh -- :0 -nolisten tcp vt1
# fi

EOF
RUN chmod +x /usr/bin/chrome.sh

# TODO: keyboard should be configurable in runtime
# TODO: actually move all input related functionality to separate layer
#RUN printf "\
#Section \"ServerFlags\"\n\
#        Option \"AutoAddDevices\" \"False\"\n\
#EndSection\n\
#\n\
#Section \"ServerLayout\"\n\
#    Identifier     \"Desktop\"\n\
#    InputDevice    \"Mouse0\" \"CorePointer\"\n\
#    InputDevice    \"Keyboard0\" \"CoreKeyboard\"\n\
#EndSection\n\
#\n\
#Section \"InputDevice\"\n\
#    Identifier \"Keyboard0\"\n\
#    Option \"CoreKeyboard\"\n\
#    Option \"Device\" \"/dev/input/event4\"\n\
#    Driver \"evdev\"\n\
#EndSection\n\
#\n\
#Section \"InputDevice\"\n\
#    Identifier \"Mouse0\"\n\
#    Driver \"mouse\"\n\
#    Option \"Protocol\" \"auto\"\n\
#    Option \"Device\" \"/dev/input/mice\"\n\
#    Option \"ZAxisMapping\" \"4 5 6 7\"\n\
#EndSection\n\
#" > /etc/X11/xorg.conf.d/10-input.conf

#CMD /usr/bin/xinit /usr/bin/xterm -- :0 -nolisten tcp vt1
#CMD /usr/bin/X :0 -nolisten tcp vt1

# Set display value to avoid passing it around. Override if needed.
ENV DISPLAY=:0

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
