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

install_apt_packages() {
    sudo apt update
    for package in $(cat "$DOTFILES/apt_packages"); do
        install_package $package
    done
}

setup_zsh() {
    if install_pkg zsh; then
        sudo chsh -s $(which zsh)
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

setup_symlinks() {
	find $(realpath $0 | xargs dirname) -maxdepth 1 -mindepth 1 -name '.*' ! -name '.git' |
    while IFS= read -r f; do
        ln -sf $f $HOME/${f##*/}
    done

    find $(realpath $0 | xargs dirname) -maxdepth 1 -mindepth 1 -name '*.zsh' |
    while IFS= read -r f; do
        ln -sf $f $HOME/.oh-my-zsh/custom/${f##*/}
    done
}

setup_docker() {
    if ! command -v docker > /dev/null 2>&1; then
        sudo apt install -y apt-transport-https ca-certificates gnupg
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian trixie stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker ${USER}
    fi
}

setup_vscode() {
    if ! command -v code > /dev/null 2>&1; then
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/microsoft-archive-keyring.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt update
        sudo apt install -y code
fi
}
#setup_symlinks
#setup_docker
#setup_vscode

install_apt_packages

