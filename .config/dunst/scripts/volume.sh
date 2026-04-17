#!/bin/bash

# Colle a liña de 'Volume' e garda a primeira porcentaxe que atopa
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n 1)
# Ao usar pactl o nivel de volume é independente o estado 'Silencio',
# comprobamos se o sink está muteado: 'yes' ou 'no'
is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# Asignar icona en función do nivel do volume 􀊡 􀊥 􀊧 􀊩
if [ "$volume" -eq 0 ]; then
    icon="􀊡     "
elif [ "$volume" -le 33 ]; then
    icon="􀊥    "
elif [ "$volume" -le 66 ]; then
    icon="􀊧   "
else
    icon="􀊩  "
fi

if [ "$is_muted" = "yes" ]; then
    icon="􀊣     "
    dunstify \
        -a "volume" \
        -t 2000 -r 2593 \
        "Silencio" \
        "<span size='30pt' rise='-13000' foreground='#b899a8'>$icon</span>"
else
    dunstify \
        -a "volume" \
        -h int:value:"$volume" \
        -t 2000 -r 2593 \
        "Volume:  $volume %" \
        "<span size='30pt' rise='-13000' foreground='#b899a8'>$icon</span>"
fi

# Axuste do tamaño da icona
# size='32pt' rise='-15000'
# size='30pt' rise='-13000'
