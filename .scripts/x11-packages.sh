#!/usr/bin/env bash

# Paquetes (orientativos) para unha nova instalación co protocolo x11

# Paquetes do repositorio oficial
PAC_PKGS=(
    xorg-server
    xorg-xinit
    xorg-xinput
    7zip
    adw-gtk-theme
    alacritty
    alsa-utils
    android-tools
    android-udev
    anki
    at-spi2-core
    base-devel
    bash-completion
    bluez-utils
    brightnessctl
    code
    cups
    dunst
    exfat-utils
    firefox
    font-manager
    git
    git-filter-repo
    git-lfs
    gnome-keyring
    gvfs-mtp
    htop
    i3-wm
    i3status
    imagemagick
    imv
    inkscape
    kitty
    libcanberra
    libreoffice-still-gl
    lightdm
    lolcat
    lxappearance
    maim
    man
    noto-fonts-cjk
    noto-fonts-emoji
    nvim
    obs-studio
    okular
    picom
    pulseaudio
    pulseaudio-alsa
    pulseaudio-bluetooth
    py3status
    python-pillow
    python-pipx
    qbittorrent
    qpdf
    ranger
    rate-mirrors
    redshift
    ripgrep-all
    rofi
    rsync
    syncthing
    texlive
    thunar
    tlp
    ttf-ibm-plex
    ttf-jetbrains-mono
    ttf-nerd-fonts-symbols-mono
    typst
    unrar
    unzip
    uv
    vlc
    vlc-plugin-ffmpeg
    xclip
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    yt-dlp
    zathura
    zathura-pdf-mupdf
)

# Paquetes para detectar particións con BitLocker
DUAL_BOOT_PKGS=(
    ntfs-3g
    os-prober
)

# Paquetes do AUR
AUR_PKGS=(
    cbonsai
    claude-desktop
    goldendict-ng
    hunspell-gl
    lightdm-mini-greeter
    neofetch
    nitrogen
    onedrive-abraunegg
    sharkfin-keyboard-bin
    slides
    spotify
    ttf-aptos
    ttf-cmu-bright
    ttf-ms-fonts
    update-grub
    visual-studio-code-bin
    zotero-bin
)

# Paquetes de Python
PY_PKGS=(
    git+https://github.com/tnwei/nbread
    photogimp
    rofimoji
    spotdl
    tldr
)

# Instalar yay se non está xa
install_yay() {
    if ! command -v yay &>/dev/null; then
        echo "Non se atopou yay. Instalando..."

        sudo pacman -S --needed --noconfirm git base-devel

        tmpdir=$(mktemp -d)
        pushd "$tmpdir" >/dev/null

        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm

        popd >/dev/null
        rm -rf "$tmpdir"

        echo "Instalación de yay completada!1 ^_^"
    else
        echo "Xa se atopou unha instalación de yay."
    fi
}

# Funcións para instalar
install_arch_official() {
    sudo pacman -Syu --needed --noconfirm "${PAC_PKGS[@]}"
}

install_aur() {
    yay -S --needed --noconfirm "${AUR_PKGS[@]}"
}

install_python() {
    for pkg in "${PY_PKGS[@]}"; do
        pipx install "$pkg"
    done
}

install_all() {
    install_arch_official
    install_yay
    install_aur
    install_python
}

# Descomentar para instalar todo:
#install_all
# Aínda que mellor:
#source x11-packages.sh
#install_arch_official
