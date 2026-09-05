# ~/.bash_aliases

# =======================
# ALIASES
# =======================

alias ls="ls --color=auto"
alias cp="cp -i"
alias v="nvim"
alias vim="nvim"
alias cal="LC_TIME=gl_ES.UTF-8 cal"
alias yayup="yay -Syu --aur"
alias base="source ~/.base/bin/activate"
alias venv="source venv/bin/activate"
alias okular="detach_app okular"

alias dot='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

alias refresh_mirrors="rate-mirrors --protocol https arch --max-delay 21600 | sudo tee /etc/pacman.d/mirrorlist"
alias cpwd='p=$(pwd); echo "$p"; echo -n "$p" | xclip -selection c && echo "Copiouse o pwd ao portapapeis ٩(^ᴗ^)۶"'
alias fail2='sudo fail2ban-client status'
alias hist_ssh='journalctl -u sshd | tail -n 100'
alias mnt='udisksctl mount -b' #  /dev/sdb1
alias umnt='udisksctl unmount -b' # /dev/sdb1
alias peli="xrandr --output HDMI-1 --mode 1920x1080 --same-as eDP-1"
alias enriba="xrandr --output HDMI-1 --mode 1920x1080 --above eDP-1 && nitrogen --restore"
alias dereita="xrandr --output HDMI-1 --auto --right-of eDP-1 && nitrogen --restore"
alias esquerda="xrandr --output HDMI-1 --auto --left-of eDP-1 && nitrogen --restore"
alias audio="alsamixer"
alias ipwhere="curl ipinfo.io"

alias mysql="/usr/bin/mariadb"
# Facer que detecte kernels: https://forum.manjaro.org/t/vscode-python-jupyter-extension-select-kernel-does-not-find-anything/169225
alias code="code --enable-proposed-api ms-toolsai.jupyter --enable-proposed-api ms-python.python"
alias flush="sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches"

# Eliminar un paquete e as súas dependencias
alias yeet='pacman -Rs'

alias vconf="cd ~/.config/nvim/"
alias bconf="nvim ~/.bashrc"
alias i3conf="nvim ~/.config/i3/config"
alias kconf="nvim ~/.config/kitty/kitty.conf"
alias snippets="cd ~/.config/nvim/lua/snippets/"
alias typstpack="cd ~/.local/share/typst/packages/local/"
alias bsc="cd ~/OneDrive/Física_USC-G1031V01/ && ls -a"
alias msc="cd ~/OneDrive/MSc/ && ls -a"

alias thm="source ~/.scripts/alacritty-toggle-theme.sh"
alias arxiv-check="~/.scripts/arxiv_monitor.py"
alias arxiv-view="~/.scripts/arxiv_view.py"

alias                    \
  tn="tmux -u -f new"    \
  ta="tmux -u -f attach"

# =======================
# FUNCIÓNS ÚTILES
# =======================

# Extractor de arquivos
ex ()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"    ;;
      *.tar.gz)    tar xzf "$1"    ;;
      *.tar.xz)    tar xvf "$1"    ;;
      *.bz2)       bunzip2 "$1"    ;;
      *.rar)       unrar x "$1"    ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar xf "$1"     ;;
      *.tbz2)      tar xjf "$1"    ;;
      *.tgz)       tar xzf "$1"    ;;
      *.zip)       unzip "$1"      ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1"       ;;
      *)           echo "'$1' non se puido extraer con ex()" ;;
    esac
  else
    echo "'$1' non é un ficheiro válido"
  fi
}

# Pechar ranger no directorio actual usando Q
# ranger() {
#    local IFS=$'\t\n'
#    local tempfile="$(mktemp -t tmp.XXXXXX)"
#    local ranger_cmd=(
#        command
#        ranger
#        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
#    )
#
#    ${ranger_cmd[@]} "$@"
#    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
#
#        cd -- "$(cat "$tempfile")"; clear || return
#    fi
#    command rm -f -- "$tempfile" 2>/dev/null
#}

# Abrir cadernos de Jupyter en conexións remotas
jpt(){
    source venv/bin/activate
    jupyter notebook --no-browser --port=$1
}

# Pequena función para sacar o sampling rate dos ficheiros de audio
spectrogram(){
    # En caso de que a entrada sexa dada coma unha ruta
    filename=$(basename "$1")
    # Pasar todo a minúsculas
    clean_name="${filename,,}"
    # Cambiar espazos por barras baixas
    clean_name="${clean_name// /_}"
    # Quitar extensión
    output_name="${clean_name%.*}"

    # Como curiosidade e por se fose útil no futuro, usando canalizacións:
    # output_name=$(basename "$1" | \
    #               tr '[:upper:]' '[:lower:]' | \
    #               tr ' ' '_' | \
    #               sed 's/\.[^.]*$//')

    ffmpeg -i "$1" -lavfi showspectrumpic=s=1024x512:legend=1 "spec_${output_name}.png"
}

# Desprender procesos do terminal de xeito que, ao pechalo, a aplicación siga en execución
detach_app() {
    nohup "$@" > /dev/null 2>&1 &
    # Ao executar, imprime na pantalla o número do traballo e o PID, para
    # evitar isto hai que meter o comando «nohup ...» entre parénteses.
}

# Xestión manual dos ventiladores
level_fan(){
    cat /proc/acpi/ibm/fan
    # Activar permisos de xestión manual
    sudo modprobe -r thinkpad_acpi && sudo modprobe thinkpad_acpi fan_control=1
    # Cambiar nivel (0-7 ou full-speed/disengaged)
    echo "level $1" | sudo tee /proc/acpi/ibm/fan
}
