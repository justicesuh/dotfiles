#!/bin/sh

DOTFILES=$(realpath $0 | xargs dirname)

ln -sf $DOTFILES/vscode/settings.json $HOME/.config/Code/User/settings.json
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.taskrc $HOME/.taskrc
ln -sf $DOTFILES/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/aliases.zsh $HOME/.oh-my-zsh/custom/aliases.zsh
