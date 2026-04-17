#!/bin/bash

brightness=$(cat /sys/class/backlight/*/brightness)
max_brightness=$(cat /sys/class/backlight/*/max_brightness)
percentage=$(( (brightness * 100) / max_brightness ))

# Usar iconas en imaxe: -i ~/.config/dunst/assets/brightness.svg \

# Asignar icona en función do nivel do brillo
# 􀡈  􀡉  􀡊  􀡋  􀡌  􀡍  􀡎  􀡏

if [ "$percentage" -le 20 ]; then
    icon="􀡌    "
elif [ "$percentage" -le 40 ]; then
    icon="􀡋    "
elif [ "$percentage" -le 60 ]; then
    icon="􀡊    "
elif [ "$percentage" -le 80 ]; then
    icon="􀡉    "
else
    icon="􀡈    "
fi

dunstify \
    -a "brillo" \
    -h int:value:"$percentage" \
    -t 2000 -r 2593 \
    "Brillo:  $percentage%" \
    "<span size='30pt' rise='-13000' foreground='#81a1c1'>$icon</span>"
