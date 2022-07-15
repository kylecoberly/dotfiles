#!/bin/bash

# Shell
OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "${OHMYZSH_DIR}" ]
then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ln -sf ./coberly-gruvbox.zsh-theme ~/.oh-my-zsh/custom/themes
chsh -s /bin/zsh $USERNAME

# Programs

sudo apt update

## Docker

sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

## Utilities

sudo apt install ranger htop ncdu nmap p7zip peek powertop tldr tree unrar whereami zsh wget curl

## Development

sudo apt install tmux neovim fonts-powerline gh git heroku postgresql
