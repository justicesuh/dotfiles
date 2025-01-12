#!/bin/sh

is_pkg_installed() {
    if dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"; then
        return 0
    else
        return 1
    fi
}

install_pkg() {
    if ! is_pkg_installed "$1"; then
        sudo apt install -y "$1"
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

if ! is_pkg_installed spotify-client; then
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install -y spotify-client
fi

if ! is_pkg_installed google-chrome-stable; then
    sudo apt install -y software-properties-common apt-transport-https ca-certificates
    curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
fi

install_pkg firefox-esr
install_pkg python3
install_pkg python3-pip

sh -c $(realpath $0 | xargs dirname)/symlinks.sh
