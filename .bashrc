#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias vim='nvim'
alias zathura='zathura --fork'
alias yayup='yay -Syu --aur'
alias base='pyenv shell 3.11.9 && source ~/base/bin/activate'

alias mnt='udiskctl mount -b' # /dev/sdb1
alias umnt='udiskctl unmount -b' # /dev/sdb1

alias dot='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'
export LD_LIBRARY_PATH="$LD_LIBRARY_PATJH:/usr/lib"


if [[ ":$PATH:" != *":/home/arebla/.local/bin:"* ]]; then
    export PATH="/home/arebla/.local/bin:$PATH"
fi
