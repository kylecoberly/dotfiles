#!/bin/bash

## Set dotfile directory
if [ "${CODESPACES}" == "true" ]; then
  DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

## Minimium Dependencies
sudo apt install -y --no-install-recommends zsh curl git

## Shell
OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "${OHMYZSH_DIR}" ]
then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

### Oh-my-zsh theme
ln -sf "${DOTFILE_DIRECTORY}/coberly-gruvbox.zsh-theme" "${HOME}/.oh-my-zsh/custom/themes"

### Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## Install Utilities
sudo apt install -y --no-install-recommends \
  ranger bat htop ncdu nmap tldr tree wget ffmpeg \
  openssh-server xclip build-essential docker-ce docker-ce-cli

## Install Roboto Nerd Font (Noto is better but it's 500MB+)
mkdir -p ~/.local/share/fonts
wget -q -O roboto.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/RobotoMono.zip \
  && unzip -q -d roboto roboto.zip \
  && cp roboto/Roboto* "$HOME/.local/share/fonts/" \
  && rm -rf roboto \
  && rm -f roboto.zip

## Environments

### Install asdf
if [[ ! -d "$HOME/.asdf" ]]
then
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf"
fi
chmod u+x "$HOME/.asdf/asdf.sh"
sh -c "$HOME/.asdf/asdf.sh"
ln -sf "${DOTFILE_DIRECTORY}/.tool-versions" "${HOME}/"

### Install all of the languages in languages.json
sudo apt install -y --no-install-recommends jq
jq -c '.languages[]' "languages.json" | while read language
do
  get() {
    property=$1
    jq -r "$language | $property"
  }

  dependencies=`get '.dependencies'`
  repo=`get '.repo'`
  target=`get '.target'`
  version=`get '.version'`

  sudo apt install -y --no-install-recommends $dependencies
  asdf plugin add "$target" "$repo"
  asdf install "$target" "$version"
  asdf global "$target" "$version"
done

## TMUX
sudo apt install -y --no-install-recommends tmux

## Neovim
sudo apt install -y --no-install-recommends neovim ripgrep fd-find
mkdir -p "${HOME}/.config/nvim" \
  && ln -sf "${DOTFILE_DIRECTORY}/neovim" "${HOME}/.config/nvim"
npm i -g neovim # Needed for Neovim
gem install neovim

## Other dotfiles
DOTFILES=(.gitconfig .gitignore .zshrc .aliases .tmux.conf .tmux.conf.local .markdownlintrc) 
for dotfile in $(echo ${DOTFILES[*]});
do
  ln -sf "${DOTFILE_DIRECTORY}/${dotfile}" "${HOME}/"
done

###################################

if [ "${CODESPACES}" == "true" ]; then
  echo "Environment setup complete" | wall
fi
