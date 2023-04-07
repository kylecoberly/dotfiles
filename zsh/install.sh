#!/bin/bash

if [ -z "$HOME" ]; then
	exit 1
fi

if [ "${CODESPACES}" == "true" ]; then
	DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
	DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get install -y --no-install-recommends zsh git curl
fi

## Install oh-my-zsh
OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "${OHMYZSH_DIR}" ]; then
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

## Theme
if [ ! -d "${HOME}/.oh-my-zsh/themes/powerlevel10k" ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/.oh-my-zsh/themes/powerlevel10k"
fi
ln -sf "${DOTFILE_DIRECTORY}/zsh/coberly-gruvbox.zsh-theme" "${HOME}/.oh-my-zsh/themes"

## Zsh plugins
if [ ! -d "${OHMYZSH_DIR}/custom/plugins/zsh-autosuggestions" ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi
if [ ! -d "${OHMYZSH_DIR}/custom/plugins/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

## Dotfile
rm "${HOME}/.zshrc"
ln -sf "${DOTFILE_DIRECTORY}/zsh/.zshrc" "${HOME}/"
