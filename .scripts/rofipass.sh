#!/usr/bin/env sh

# Source: https://codeberg.org/aocoronel/rofipass

die() {
  message=$1
  COLOR_RED="$(tput setaf 1)"
  COLOR_RESET=$(tput sgr0)
  printf "%s[%s]:%s %s\n" "$COLOR_RED" "FATAL" "${COLOR_RESET}" "${message}"
  exit 1
}

# Supported: X11 and Wayland
clipmethod="$XDG_SESSION_TYPE"

# Notify-send title
notify_title="rofipass"
notify_id=2594

# You can set your EDITOR, or let xdg-open handle it
# If you use a terminal editor, you can set "st -e nano"
[ -z "$EDITOR" ] && EDITOR=${EDITOR:-xdg-open}
export EDITOR

# Terminal to use
# This is only used to open a terminal to interact with "tomb" to open
# and close your encrypted passwordstore, since it requires sudo or doas
term=${term:-xterm}

# Waiting time to clear your clipboard in seconds
time=${time:-5}

passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
[ ! -d "$passdir" ] && die "Non se atopou o directorio do «Password Store»."

# Dependencies

[ -x "$(command -v rofi)" ] || die "«rofi» non está instalado."
[ -x "$(command -v pass)" ] || die "«pass» non está instalado."

# === Configuration ===

# Colors
help_color="#98C379"
div_color="#fdf6e3"
label="#f067fc"

# Bindings
kb_copy_email="Ctrl+2" # EMAIL
kb_copy_otp="Ctrl-1"   # COPY TOTP
kb_add_pass="Ctrl+r"   # PASSWORD
kb_add_otp="Ctrl+t"    # ADD TOTP
kb_delete="Ctrl-x"     # DELETE
kb_edit="Ctrl+y"       # EDIT
kb_close_tomb="Ctrl-z" # CLOSE TOMB
kb_open_tomb="Ctrl-o"  # OPEN TOMB

# Icons directoriy
icon_dir="$HOME/.cache/rofipass/icons"
icon_color="#f0c674" #ffcc00

generate_icons() {
  [ -f "$icon_dir/password.png" ] && return
  mkdir -p "$icon_dir"
  render() { convert -background none -fill "$icon_color" \
      -font "SF-Pro-Medium" \
    -pointsize 96 -gravity center -size 128x128 label:"$1" "$icon_dir/$2.png"; }
  render "􀟖" password
  render "􀍖 " email
  render "􀈒" delete
  render "􀒋" edit
  render "􀎡" tomb_open
  render "􀎥" tomb_close
}

# 􀈑 􀈒  􀍕  􀍖   􀎡  􀎥  􀟖  􀒋  􀖔  􂅧  􂏫

# === rofipass ===

notify() {
  message="$1"
  urgency="$2"
  icon="${3:-password}"
  echo "$message" # Message is logged to the tty on purpose
  #notify-send -a "$notify_title" -u "$urgency" "$notify_title" "$message"
  dunstify -a "$notify_title" -u "$urgency" -r "$notify_id" \
    -i "$icon_dir/$icon.png" \
    "$notify_title" "$message"
}

notify_wait() {
  message="$1"
  icon="${2:-password}"
  echo "$message" # Message is logged to the tty on purpose
  # The --expire-time and --wait options serve as a visual clue
  # to show when your clipboard has been cleared.
  #notify-send -a "$notify_title" -u "normal" "$notify_title" "$message" --expire-time="$time"000 --wait
  dunstify -a "$notify_title" -u normal -r "$notify_id" -t "$time"000 \
    -i "$icon_dir/$icon.png" \
    "$notify_title" "$message"
}

die_notify() {
  message=$1
  dunstify -a "$notify_title" -u normal -r "$notify_id" -t "$time"000 \
    "$notify_title" "$message"
  die "$message"
}

version() {
  echo "v20260905"
}

usage() {
  cat <<EOF
rofipass | fully-featured rofi script for passwordstore

Usage: rofipass [OPTIONS]

Options:
  -e <EDITOR>   Set editor
  -f            Lift swap restrictions (tomb-only)
  -h            Display this help message and exit
  -l <LENGTH>   Default password length to be generated
  -t <TERM>     Default terminal emulator (tomb-only)
  -v            Display the current version number
  -T <TIME>     Clearing time in seconds

Example:
  rofipass -f -l 72 -t kitty -e emacs -T 10
  rofipass -f -l 72 -t kitty -e "st -e nvim" -T 10
EOF
}

# 🔑􀟕􀟒􀟖

_rofi() {
  rofi -p '🔑 Contrasinais' \
    -dmenu \
    -i \
    -no-levenshtein-sort \
    -theme "$HOME/.config/rofi/launcher/launcher-style.rasi" \
    -theme-str 'window { width: 40%; height: 50%; }' \
    "$@"
}

rofi_tiny() {
  rofi -p '🔑' -dmenu -i -no-levenshtein-sort -width 1000 -lines 0 -theme-str "window { width: 25em; } listview { lines: $1; } entry { placeholder: '$2';}"
}

# If a line starts with email=myemail@mail.com, copies it
copy_email() {
  email=$(pass "$menu" | sed -n 's/^email=//p')
  [ -z "$email" ] && die_notify "$menu non contén un email"
  case "$clipmethod" in
  "x11")
    xclip -selection clipboard <<< "$email" || die_notify "Non se puido copiar o email."
    notify_wait "Email copiado ao portapapeis. Borrando en $time segundos" "email"
    ;;
  "wayland")
    wl-copy "$email" || die_notify "Non se puido copiar o email."
    notify_wait "Email copiado ao portapapeis. Borrando en $time segundos" "email"
    ;;
  esac
  clearboard
}

append_otp() {
  case "$clipmethod" in
  "x11")
    contents=$(xclip -selection clipboard -o)
    ;;
  "wayland")
    contents=$(wl-paste)
    ;;
  esac

  err=$?

  # If you don't have the QR code, this attempts to handle the secret key directly
  if [ -n "$contents" ] && [ "$err" -eq 0 ]; then
    otp_secret="otpauth://totp/passwordstore:none?secret=$contents&period=30&digits=6"
    echo "$otp_secret" | pass otp append "$menu"
    err=$?
    [ "$err" -eq 0 ] && {
      notify "Inserted OTP successfully to $menu" "normal"
      return
    }
  fi

  # If you have the QR code PNG saved to your clipboard, this attempts to parse it
  [ -x "$(command -v zbarimg)" ] || die_notify "«zbarimg» non está instalado."

  case "$clipmethod" in
  "x11")
    xclip -o | zbarimg -q --raw - | pass otp append "$menu" || die_notify "failed to append OTP to $menu"
    notify "Inserted OTP successfully to $menu" "normal"
    ;;
  "wayland")
    wl-paste --type image/png | zbarimg -q --raw - | pass otp append "$menu" || die_notify "failed to append OTP to $menu"
    notify "Inserted OTP successfully to $menu" "normal"
    ;;
  esac
}

clearboard() {
  case "$clipmethod" in
  "x11") echo "" | xclip -sel clip ;;
  "wayland") echo "" | wl-copy ;;
  esac
}

tomb_open() {
  if [ -n "$FORCE" ]; then
    $term -e sh -c "pass open -f"
  else
    $term -e sh -c "pass open"
  fi
}

tomb_close() {
  $term -e sh -c "pass close"
  pass_val=$?
  if [ "$pass_val" -ne 0 ]; then
    die_notify "failed to close tomb."
  else
    notify "Your password tomb has been closed" "normal" "tomb_close"
  fi
}

deleteMenu() {
  delask=$(printf "1. Si\n2. Non" | rofi_tiny 2 "Tes a certeza de querer eliminala?")
  val=$?
  [ $val -eq 1 ] && {
    notify "Cancelled" "low" "delete"
    main
  }
  [ "$delask" = "1. Si" ] && pass rm -f "$menu" && notify "Eliminouse $menu" "normal" "delete"
  main
}

add_password() {
  length=${length:-72}
  addmenu=$(rofi_tiny 0 "Insire o nome do contrasinal:")
  val=$?
  if [ $val -eq 1 ]; then
    notify "Cancelouse engadir contrasinal." "low" "password"
    main
  elif [ $val -eq 0 ]; then
    pass generate "$addmenu" "$length"
    if [ $val -eq 1 ]; then
      notify "Non se puido engadir o contrasinal" "critical" "password"
      main
    else
      notify "Engadiuse $addmenu" "normal" "password"
    fi
  fi
  main
}

edit_password() {
  $term -e sh -c 'pass edit "$1"' sh "$menu" || die "$EDITOR: non puido editar $menu"
}

main() {
  enable_tomb=0
  enable_otp=0
  generate_icons

  if ! command -v "tomb" >/dev/null 2>&1; then
    enable_tomb=1
  fi

  pass otp -h >/dev/null 2>&1 || enable_otp=1

  HELP=""

  HELP="$HELP<span color='${label}'>Accións: </span><span color='${help_color}'>${kb_add_pass}</span>: Engadir <span color='${div_color}'>|</span> <span color='${help_color}'>${kb_delete}</span>: Eliminar <span color='${div_color}'>|</span> <span color='${help_color}'>${kb_edit}</span>: Editar"

  ZBAR_HELP=" <span color='${div_color}'>|</span> <span color='${help_color}'>${kb_add_otp}</span>: Engadir OTP"
  HELP="$HELP$ZBAR_HELP"

  HELP="$HELP
<span color='${label}'>Copiar: </span><span color='${help_color}'>Enter</span>: Copiar contrasinal <span color='${div_color}'>|</span> <span color='${help_color}'>${kb_copy_email}</span>: Copiar email"

  if [ "$enable_otp" -eq 0 ]; then
    OTP_HELP=" <span color='${div_color}'>|</span> <span color='${help_color}'>${kb_copy_otp}</span>: Copy OTP"
    HELP="$HELP$OTP_HELP"
  fi

  if [ "$enable_tomb" -eq 0 ]; then
    TOMB_HELP="<span color='${label}'>Tomb: </span><span color='${help_color}'>${kb_close_tomb}</span>: Close Tomb <span color='${div_color}'>|</span> <span color='${help_color}'>${kb_open_tomb}</span>: Open Tomb"
    HELP="$HELP
$TOMB_HELP"
  fi

  pass=$(find -L "$passdir" -type f -name '*.gpg' -printf '%P\n' | sed 's/\.gpg//')
  menu=$(echo "${pass}" | _rofi -mesg "${HELP}" -kb-custom-1 "${kb_add_pass}" -kb-custom-2 "${kb_copy_otp}" -kb-custom-3 "${kb_delete}" -kb-custom-4 "${kb_edit}" -kb-custom-5 "${kb_close_tomb}" -kb-custom-6 "${kb_open_tomb}" -kb-custom-7 "${kb_copy_email}" -kb-custom-8 "${kb_add_otp}")

  val=$?
  case "$val" in
  1) exit ;;
  12) deleteMenu ;;
  11) # OTP Copy
    [ "$enable_otp" -eq 0 ] && {
      timeout 3 pass otp -c "$menu" || die_notify "Non se puido copiar o OTP"
      notify_wait "Copiouse ao portapapeis. Borrando en $time segundos" "tomb_open"
      clearboard
    }
    ;;
  10) add_password ;;
  13) edit_password ;;
  14) [ "$enable_tomb" -eq 0 ] && tomb_close ;;
  15) [ "$enable_tomb" -eq 0 ] && tomb_open ;;
  16) copy_email ;;
  17) append_otp ;;
  0) # Password Copy
    pass -c "$menu" || die_notify "Non se puido copiar o contrasinal"
    notify_wait "Contrasinal copiado ao portapapeis. Borrando en $time segundos" "password"
#    clearboard
    ;;
  esac
}

while getopts ":hvfl:t:T:e:" opt; do
  case "$opt" in
  h)
    usage
    exit 0
    ;;
  e)
    EDITOR="$OPTARG"
    ;;
  v)
    version
    exit 0
    ;;
  f)
    FORCE=true
    ;;
  l)
    length="$OPTARG"
    ;;
  t)
    term="$OPTARG"
    ;;
  T)
    time="$OPTARG"
    ;;
  ?)
    die "Opción inválida: '-$OPTARG'"
    ;;
  esac
done

shift $((OPTIND - 1))

main
