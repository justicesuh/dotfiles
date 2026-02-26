#!/bin/sh

is_pkg_installed() {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

install_pkg() {
    if ! is_pkg_installed "$1"; then
        sudo apt install -y "$1"
        return 0
    else
        return 1
    fi
}

if install_pkg zsh; then
    sudo chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

