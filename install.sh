#!/bin/sh

dockItem() {
	echo "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
}

echo 'Installing command line tools'
xcode-select --install

rm -rf ~/.zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
source ~/.zshrc

if ! which brew; then
	echo 'Installing homebrew'
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo 'Homebrew already installed'
fi

brew update
brew tap homebrew/bundle
brew bundle --file ~/.dotfiles/Brewfile


[ ! -d ~/Code ] && mkdir ~/Code

defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-apps -array \
	"$(dockItem '/System/Applications/Launchpad.app')" \
	"$(dockItem '/System/Applications/System Settings.app')" \
	"$(dockItem '/Applications/Firefox.app')" \
	"$(dockItem '/Applications/Google Chrome.app')" \
	"$(dockItem '/System/Applications/Utilities/Terminal.app')" \
	"$(dockItem 'Applications/Visual Studio Code.app')" \
	"$(dockItem '/Applications/Spotify.app')"
killall Dock

