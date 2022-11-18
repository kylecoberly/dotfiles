#!/bin/bash

## Programs

sudo apt update
sudo apt install zsh

## Shell

OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "${OHMYZSH_DIR}" ]
then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

### Utilities

sudo apt install -y --no-install-recommends ranger bat htop ncdu nmap tldr tree wget

### Development

sudo apt install -y --no-install-recommends tmux neovim

#### Node

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node

## Link Files

if [ "${CODESPACES}" == "true" ]; then
  DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

ln -sf "${DOTFILE_DIRECTORY}/coberly-gruvbox.zsh-theme" "${HOME}/.oh-my-zsh/custom/themes"
mkdir -p "${HOME}/.config/nvim" && ln -sf "${DOTFILE_DIRECTORY}/init.vim" "${HOME}/.config/nvim"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

DOTFILES=(.gitconfig .gitignore .zshrc .aliases .tmux.conf .tmux.conf.local) 
for dotfile in $(echo ${DOTFILES[*]});
do
  ln -sf "${DOTFILE_DIRECTORY}/${dotfile}" "${HOME}/"
done

###################################

nvim --headless +PlugInstall! +qall

if [ "${CODESPACES}" == "true" ]; then
  echo "Environment setup complete" | wall
fi
