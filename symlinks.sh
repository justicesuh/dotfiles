#!/bin/sh

DOTFILES=$(realpath $0 | xargs dirname)

sudo rm -rf $HOME/.vimrc > /dev/null 2>&1

ln -sf $DOTFILES/.vimrc $HOME/.vimrc

