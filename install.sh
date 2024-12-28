#!/bin/sh

sudo apt update
sudo apt install -y curl git vim

if ! command -v zsh > /dev/null 2>&1; then
	sudo apt install -y zsh
	sudo chsh -s $(which zsh)
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

