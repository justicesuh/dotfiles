#!/bin/sh

is_pkg_installed() {
    if dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"; then
        return 0
    else
        return 1
    fi
}

sudo apt update
sudo apt install -y curl git vim xclip

if ! is_pkg_installed zsh; then
    sudo apt install -y zsh
    sudo chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

if is_pkg_installed gnome-games; then
    sudo apt purge --autoremove -y gnome-games
fi
if command -v libreoffice > /dev/null 2>&1; then
    sudo apt purge --autoremove -y "libreoffice*"
fi
sudo apt clean

if ! command -v docker > /dev/null 2>&1; then
    sudo apt install -y apt-transport-https ca-certificates gnupg
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker ${USER}
fi

if ! command -v code > /dev/null 2>&1; then
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
fi

if ! is_pkg_installed firefox-esr; then
    sudo apt install -y firefox-esr
fi

sh -c ./symlinks.sh
