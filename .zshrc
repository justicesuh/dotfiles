export DOTFILES="$HOME/.dotfiles"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

zstyle ':completion:*:*:-command-:*:*' sort true
zstyle ':completion:*' group-order builtins functions commands aliases

source $ZSH/oh-my-zsh.sh

