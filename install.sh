#!/bin/bash

# Shell
#OHMYZSH_DIR="$HOME/.oh-my-zsh"
#if [ ! -d "${OHMYZSH_DIR}" ]
#then
  #sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#fi
#ln -sf ./coberly-gruvbox.zsh-theme $HOME/.oh-my-zsh/custom/themes
# chsh -s /bin/zsh $USERNAME

# Programs

sudo apt update

## Utilities

sudo apt install -y --no-install-recommends ranger bat htop ncdu nmap tldr tree wget

## Development

sudo apt install -y --no-install-recomends tmux neovim

## Link Files

#DOTFILES=(.gitconfig .zshrc .aliases init.vim .tmux.conf, .tmux.conf.local) 
#for dotfile in $(echo ${DOTFILES[*]});
#do
  #sudo rm -f $HOME/$(echo $dotfile)
  #ln -sf $(echo $dotfile) $HOME/$(echo $dotfile)
#done

pwd | wall
echo "Environment setup complete" | wall
