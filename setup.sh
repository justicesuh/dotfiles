#!/bin/sh

DOTFILES=$(realpath $0 | xargs dirname)

is_package_installed() {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

install_package() {
    if ! is_package_installed "$1"; then
        sudo apt install -y "$1"
        return 0
    else
        return 1
    fi
}

install_packages() {
    for i in "$@"; do
        install_package $i
    done
}

add_keys() {
    install_packages apt-transport-https ca-certificates gnupg jq
    for key in $(jq -c '.[]' "$DOTFILES/keys.json"); do
        url=$(echo "$key" | jq -r '.url')
        location=$(echo "$key" | jq -r '.location')
        if [ ! -f "$location" ]; then
            sudo mkdir -p "$(dirname "$location")"
            curl -fsSL "$url" | sudo gpg --dearmor -o "$location"
        fi
    done
}

add_sources() {
    for f in "$DOTFILES/sources.list.d"/*.list; do
        name=$(basename "$f")
        if [ ! -f "/etc/apt/sources.list.d/$name" ]; then
            sed "s/ARCH/$(dpkg --print-architecture)/g" "$f" | sudo tee "/etc/apt/sources.list.d/$name" > /dev/null
        fi
    done
}

install_apt_packages() {
    for package in $(cat "$DOTFILES/apt_packages"); do
        install_package $package
    done
}

setup_zsh() {
    if install_package zsh; then
        sudo chsh -s $(which zsh)
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

setup_symlinks() {
	find $(realpath $0 | xargs dirname) -maxdepth 1 -mindepth 1 -name '.*' ! -name '.git' ! -name '.gitignore' |
    while IFS= read -r f; do
        ln -sf $f $HOME/${f##*/}
    done

    find $(realpath $0 | xargs dirname) -maxdepth 1 -mindepth 1 -name '*.zsh' |
    while IFS= read -r f; do
        ln -sf $f $HOME/.oh-my-zsh/custom/${f##*/}
    done
}

setup_docker() {
    sudo usermod -aG docker ${USER}
}

setup_zsh
setup_symlinks
add_keys
add_sources
sudo apt update
install_apt_packages
#setup_docker

