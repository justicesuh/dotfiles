#!/bin/sh

sudo apt update
sudo apt install -y curl git vim

if ! command -v zsh > /dev/null 2>&1; then
    sudo apt install -y zsh
    sudo chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

if dpkg -s gnome-games | grep "Status" > /dev/null 2>&1; then
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

