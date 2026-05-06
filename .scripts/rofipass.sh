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

# You can set your EDITOR, or let xdg-open handle it
# If you use a terminal editor, you can set "st -e nano"
[ -z "$EDITOR" ] && EDITOR=${EDITOR:-xdg-open}

# Terminal to use
# This is only used to open a terminal to interact with "tomb" to open
# and close your encrypted passwordstore, since it requires sudo or doas
term=${term:-xterm}

# Waiting time to clear your clipboard in seconds
time=${time:-5}

passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
[ ! -d "$passdir" ] && die "no password directory found"

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

# === rofipass ===

notify() {
  message="$1"
  urgency="$2"
  echo "$message" # Message is logged to the tty on purpose
  #dunstify "$notify_title" "$message"
  notify-send -u "$urgency" "$notify_title" "$message"
}

notify_wait() {
  message="$1"
  echo "$message" # Message is logged to the tty on purpose
  # The --expire-time and --wait options serve as a visual clue
  # to show when your clipboard has been cleared.
  notify-send -u "normal" "$notify_title" "$message" --expire-time="$time"000 --wait
}

die_notify() {
  message=$1
  notify "$message" "normal"
  die "$message"
}

version() {
  echo "v1.2.0"
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
    xclip "$email" || die_notify "Non se puido copiar o email."
    notify_wait "Copiouse ao portapapeis. Borrando en $time segundos" "normal"
    ;;
  "wayland")
    wl-copy "$email" || die_notify "Non se puido copiar o email."
    notify_wait "Copiouse ao portapapeis. Borrando en $time segundos" "normal"
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
    notify "Your password tomb has been closed" "normal" 0
  fi
}

deleteMenu() {
  delask=$(printf "1. Si\n2. Non" | rofi_tiny 2 "Tes a certeza de querer eliminala?")
  val=$?
  [ $val -eq 1 ] && {
    notify "Cancelled" "low" 0
    main
  }
  [ "$delask" = "1. Si" ] && pass rm -f "$menu" && notify "Eliminouse $menu" "normal" 0
  main
}

add_password() {
  length=${length:-72}
  addmenu=$(rofi_tiny 0 "Insire o nome do contrasinal:")
  val=$?
  if [ $val -eq 1 ]; then
    notify "Cancelled" "low" 0
    main
  elif [ $val -eq 0 ]; then
    pass generate "$addmenu" "$length"
    if [ $val -eq 1 ]; then
      notify FATAL "Non se puido engadir o contrasinal" 0
      main
    else
      notify "Engadiuse $addmenu" "normal" 0
    fi
  fi
  main
}

edit_password() {
  pass edit "$menu" || die "$EDITOR: non puido editar $menu"
}

main() {
  enable_tomb=0
  enable_otp=0

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
      timeout 3 pass otp -c "$menu" || die_notify "Non se puido copiar o OTP" "normal"
      notify_wait "Copiouse ao portapapeis. Borrando en $time segundos" "normal"
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
    pass -c "$menu" || die_notify "Non se puido copiar o contrasinal" "normal"
    notify_wait "Copiouse ao portapapeis. Borrando en $time segundos" "normal"
    clearboard
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
    die "opción inválida '-$OPTARG'"
    ;;
  esac
done

shift $((OPTIND - 1))

main
