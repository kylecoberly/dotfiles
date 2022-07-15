#!/bin/bash

# Shell
OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "${OHMYZSH_DIR}" ]
then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Programs

sudo apt update

## Utilities

sudo apt install -y --no-install-recommends ranger bat htop ncdu nmap tldr tree wget

## Development

sudo apt install -y --no-install-recommends tmux neovim
#if [command -v nvm]
#then
  nvm install node
#fi
#if [command -v pip]
#then
  pip install pynvim
#fi

## Link Files

ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/coberly-gruvbox.zsh-theme $HOME/.oh-my-zsh/custom/themes
mkdir -p $HOME/.config/nvim && ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/init.vim $HOME/.config/nvim
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

DOTFILES=(.gitconfig .zshrc .aliases .tmux.conf .tmux.conf.local) 
for dotfile in $(echo ${DOTFILES[*]});
do
  ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/$(echo $dotfile) $HOME/$(echo $dotfile)
done

echo "Environment setup complete" | wall
