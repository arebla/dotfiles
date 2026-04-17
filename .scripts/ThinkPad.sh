#!/bin/sh

# Find device and its options
#xinput --list
#xinput --list-props <device id>

#TrackPad settings
xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1
xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Accel Speed" 0.30
xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1

#xinput --set-prop "PS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1
#xinput --set-prop "PS/2 Synaptics TouchPad" "libinput Accel Speed" 0.30
#xinput --set-prop "PS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1

#xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Accel Profile Enabled" 1 0
#xinput --set-prop "SynPS/2 Synaptics Touchpad" "libinput Scrolling Pixel Distance" 15

#TrackPoint settings
xinput --set-prop "TPPS/2 Elan TrackPoint" "libinput Accel Speed" 0.95
xinput --set-prop "TPPS/2 Elan TrackPoint" "libinput Accel Profile Enabled" 0 1
xinput --set-prop "TPPS/2 Elan TrackPoint" "Coordinate Transformation Matrix" 2. 0 0 0 2. 0 0 0 1.

trackpoint_id=$(xinput | grep -i "Trackpoint" | sed 's/^.*id=\([0-9]*\)[ \t].*$/\1/')
xinput set-button-map $trackpoint_id 1 0 3


# TrackPoint alternative: create local-overrides.quirks in /usr/share/libinput or /etc/libinput.
# [Trackpoint P14s]
# MatchUdevType=pointingstick
# AttrTrackpointMultiplier=1.75
#
# Event id on xinput --list-props and check if applied with
# libinput quirks list /dev/input/event12

xset r rate 400 50

# Map the caps lock to key to super
#setxkbmap -option caps:super -variant altgr-intl
#setxkbmap -option caps:swapescape

# Laptop built-in keyboard (Spanish ISO)
laptop_id=$(xinput list | grep "AT Translated Set 2 keyboard" | grep -o "id=[0-9]*" | cut -d= -f2)
#if [ -n "$laptop_id" ]; then
#    setxkbmap -device "$laptop_id" es
#fi

# External 2.4G wireless or wired keyboard (English US)
# Picks the first matching "2.4G Wireless Keyboard" or "AL66" that sends keycodes
external_id=$(xinput list | grep -E "2.4G Wireless Keyboard|AL66" | grep -v "Consumer\|System\|Mouse" | grep -o "id=[0-9]*" | head -1 | cut -d= -f2)
if [ -n "$external_id" ]; then
    setxkbmap -device "$external_id" us
    # Compose key to right alt
    setxkbmap -device "$external_id" -option compose:ralt
    setxkbmap -device "$laptop_id" es
    setxkbmap -device "$laptop_id" -option ""
    export XCOMPOSEFILE="$HOME/.XCompose.external"
else
    export XCOMPOSEFILE="$HOME/.XCompose.laptop"
fi
