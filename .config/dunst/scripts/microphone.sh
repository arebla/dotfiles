#!/bin/bash

# Comproba se o 'Source' está muteado: 'yes' ou 'no'
is_muted=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

# Asignar icona en función do estado
if [ "$is_muted" = "yes" ]; then
    icon="           􀊳"
else
    icon="           􀊱"
fi


dunstify \
    -a "microfono" \
    -t 2000 -r 2593 \
    " " \
    "<span size='30pt' rise='-13000' foreground='#ccccff'>$icon</span>"
