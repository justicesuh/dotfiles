#!/bin/sh

DOTFILES=$(realpath $0 | xargs dirname)

ln -sf $DOTFILES/vscode/settings.json $HOME/.config/Code/User/settings.json
ln -sf $DOTFILES/.vimrc $HOME/.vimrc

