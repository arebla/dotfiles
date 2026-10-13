#!/bin/sh

# Increase the key speed via a rate change
xset r rate 400 50

# Map the caps lock to key to super
#setxkbmap -option caps:super -variant altgr-intl
#setxkbmap -option caps:swapescape

# But when it is pressed only once, treat it as escape
#killall xcape 2>/dev/null; xcape -e 'Super_L=Escape'

# Map the menu button to right super as well
#xmodmap -e 'keycode 135 = Super_R'
