# ~/.bash_profile

# Este ficheiro execútase unha soa vez ao iniciar sesión no sistema. A orde na
# que se procuran as configuracións é «/etc/profile» (xeral), «~/.bash_profile»
# (usuario), «~/.bash_login» (usuario) e «~/.profile» (usuario); cando se atopa
# a primeira configuración de usuario termínase o proceso de busca.


# Variables de contorna
export TEXMFHOME="$HOME/.config/texmf" # Check with "kpsewhich -var-value TEXMFHOME"
export GDK_USE_PORTAL=1
export QT_QPA_PLATFORMTHEME=xdgdesktopportal
export XDG_CURRENT_DESKTOP=i3
#export GDK_DPI_SCALE=1.00
#export QT_SCALE_FACTOR=1.00

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# PATH centralizado
export PATH="$HOME/.local/bin:$GEM_HOME/bin:$PATH"

# Cargar o .bashrc para sesións interactivas
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Inicio de sesión automático e executar startx
#if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
#    exec startx
#fi

# Notas:
# Usar export QT_QPA_PLATFORMTHEME=gtk3 resulta nun comportamento moi
# inconsistente: unifícase o file picker pero como GTK e QT xestionan o DPI de
# xeito distinto o resultado é tamaños de fonte demasiado grandes/pequenos e as
# variables de entorno de QT non van xd.
