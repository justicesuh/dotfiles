#!/bin/sh

echo "Installing command line tools..."
xcode-select --install

rm -rf ~/.zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
source ~/.zshrc

if ! which brew; then
	echo "Installing homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew already installed..."
fi

brew update

brew tap homebrew/bundle
brew bundle --file ~/.dotfiles/Brewfile

mkdir ~/Code

