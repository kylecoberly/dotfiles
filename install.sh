#!/bin/bash

# Install oh-my-zsh and link the theme
OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "${OHMYZSH_DIR}" ]
then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ln -sf ./coberly-gruvbox.zsh-theme ~/.oh-my-zsh/custom/themes

#Remove old dotfiles and replace them for the host machine
DOTFILES=(.gitconfig .bashrc .zshrc .aliases init.vim .tmux.conf, .tmux.conf.local) 
for dotfile in $(echo ${DOTFILES[*]});
do
  sudo rm -rf ~/$(echo $dotfile)
  ln -sf $(echo $dotfile) ~/$(echo $dotfile)
done
