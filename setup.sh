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

setup_zsh
setup_symlinks
setup_docker

install_pkg python3
install_pkg python3-pip
