# ~/.bashrc

# Se non estamos nunha sesión interactiva, saír
[[ $- != *i* ]] && return

# Completado
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# =======================
# EXPORTS
# =======================

export EDITOR='nvim'
export VISUAL='nvim'
export BROWSER=firefox
export MANPAGER='nvim +Man!'
export LD_LIBRARY_PATH=""

# =======================
# ALIASES E FUNCIÓNS
# =======================
# Nota: os export hérdanse de procesos pais (iniciar sesión) a fillos, pero os
# aliases non. Porén, é necesario facerlles source cada vez que se abre un
# terminal.

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases


# =======================
# HISTORIAL DO BASH
# =======================

# Fontes:
# - https://excessivelyadequate.com/posts/history.html

# Número de liñas do historial que se len en cada sesión
export HISTSIZE=1000000

# Historial con lonxitude ilimitada
export HISTFILESIZE=""

# Ignorar duplicados e liñas que comezan cun espazo
export HISTCONTROL=ignoreboth

# Engadir sesión actual ao ficheiro do historial en lugar de sobrescribir
shopt -s histappend

# Combinar comandos multiliña no historial
shopt -s cmdhist

# Engadir ao historial no momento (e non só ao saír do terminal)
PROMPT_COMMAND="$PROMPT_COMMAND; history -a"


# =======================
# COUSIÑAS
# =======================

#export PYENV_ROOT="$HOME/.pyenv"
#[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init - bash)"
