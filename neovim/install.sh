#!/bin/bash

# Depends on Node and Ruby, plus Brew (MacOS)

if [ -z "$HOME" ]; then
	exit 1
fi

if [ "${CODESPACES}" == "true" ]; then
	DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
	DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

## Install dependencies
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get install -y --no-install-recommends neovim ripgrep fd-find >/dev/null
elif [[ "$OSTYPE" == "darwin"* ]]; then
	brew install neovim ripgrep fd-find >/dev/null
fi

## Link dotfiles
ln -sf "${DOTFILE_DIRECTORY}/neovim" "${HOME}/.config/nvim"

## Install language dependencies
npm i -g neovim >/dev/null
gem install neovim >/dev/null
