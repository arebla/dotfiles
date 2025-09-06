#!/usr/bin/env bash
# Paquetes para nova instalación en wayland

# Paquetes do repositorio oficial
PAC_PKGS=(
  wayland
  kitty
  greetd
  greetd-tuigreet
  swayfx
  swaybg
  nvim
  firefox
  rofi-wayland
  gammastep
  ranger
  base-devel
  git
  i3status
  py3status
  okular
  unzip
  wl-clipboard
  man
  vlc
  htop
  slurp
  grim
  imagemagick
  python-pillow
  python-pipx
  zathura
  zathura-pdf-mupdf
  texlive
  imv
  pulseaudio
  font-manager
  ttf-ibm-plex
  ttf-jetbrains-mono
  ttf-nerd-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  android-udev
  gvfs-mtp
)

# Paquetes do AUR
AUR_PKGS=(
  neofetch
  ttf-aptos
  ttf-ms-fonts
)

# Paquetes de Python
PY_PKGS=(
  git+https://github.com/tnwei/nbread # Preview ipynb on ranger
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
    echo "yay xa instalado."
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
  install_yay
  install_arch_official
  install_aur
  install_python
}

# Descomentar para instalar todo:
#install_all
# Mellor:
#source fresh-install-packages.sh
#install_arch_official
