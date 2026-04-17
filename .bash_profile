# ~/.bash_profile

# Este ficheiro execútase unha soa vez ao iniciar sesión no sistema

# Variables de contorna
export GDK_USE_PORTAL=1
export XDG_CURRENT_DESKTOP=i3
export GDK_DPI_SCALE=1.00
export QT_SCALE_FACTOR=1.00
export QT_QPA_PLATFORMTHEME=gtk3
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# PATH centralizado
export PATH="$HOME/.local/bin:$PATH"

# Cargar o .bashrc para sesións interactivas
[[ -f ~/.bashrc ]] && . ~/.bashrc
