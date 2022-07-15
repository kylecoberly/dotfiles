#!/bin/bash

# Shell
OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "${OHMYZSH_DIR}" ]
then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ln -sf ./coberly-gruvbox.zsh-theme ~/.oh-my-zsh/custom/themes
# chsh -s /bin/zsh $USERNAME

# Programs

sudo apt update

## Utilities

sudo apt install -y ranger htop ncdu nmap p7zip peek powertop tldr tree unrar whereami zsh wget curl

## Development

sudo apt install -y tmux neovim fonts-powerline

## Link Files

DOTFILES=(.gitconfig .zshrc .aliases init.vim .tmux.conf, .tmux.conf.local) 
for dotfile in $(echo ${DOTFILES[*]});
do
  sudo rm -f ~/$(echo $dotfile)
  ln -sf $(echo $dotfile) ~/$(echo $dotfile)
done
