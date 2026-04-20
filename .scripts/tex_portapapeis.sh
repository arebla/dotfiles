#!/bin/bash

# Ruta do ficheiro temporal. Ao usar mktemp garantízase que o nome sexa único
tmpfile=$(mktemp /tmp/tex-XXXXXX.tex)

# Abrir o terminal de Kitty con configuración específica de nvim
# - Non fai falla gardar o ficheiro, con Ctrl + q xa se copia ao portapapeis
kitty -o font_size=12 --class "LaTeX portapapeis" -e nvim \
    -c "set laststatus=0" \
    -c "set noshowmode" \
    -c "set cmdheight=0" \
    -c "set noruler" \
    -c "lua vim.keymap.set({'n', 'i'}, '<C-q>', function() \
        vim.cmd('silent w !xclip -selection clipboard -f') \
        vim.cmd('q!') \
    end, { buffer = true })" \
    "$tmpfile"

# Elimina o ficheiro termporal ao pechar nvim (se non se borrase, encargariase
# o servizo de ficheiros temporais de systemd, mais é boa práctica)
rm "$tmpfile"
