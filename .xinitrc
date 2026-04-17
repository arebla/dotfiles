# ~/.xinitrc

# Este ficheiro NON é necesario porque o sistema usa LightDM como Display
# manager no lugar de 'startx'. Pode ser útil ao iniciar sesión dende a TTY sen
# LightDM.

dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Recursos do sistema e do usuario
[[ -f /etc/X11/xinit/.Xresources ]] && xrdb -merge /etc/X11/xinit/.Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Mapas de teclado
[[ -f /etc/X11/xinit/.Xmodmap ]] && xmodmap /etc/X11/xinit/.Xmodmap
# [[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Scripts de inicialización do sistema
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Sincronización de D-Bus
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Xestor de xanelas
exec i3
