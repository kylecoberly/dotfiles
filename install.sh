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
	sudo apt-get update >/dev/null
fi

source "${DOTFILE_DIRECTORY}/zsh/install.sh" >/dev/null
echo "Shell configured..."
source "${DOTFILE_DIRECTORY}/apps/install.sh" >/dev/null
echo "Apps configured..."
source "${DOTFILE_DIRECTORY}/environments/install.sh" >/dev/null
echo "Environments configured..."
source "${DOTFILE_DIRECTORY}/alacritty/install.sh" >/dev/null
echo "Alacritty configured"
source "${DOTFILE_DIRECTORY}/tmux/install.sh" >/dev/null
echo "TMUX configured..."
source "${DOTFILE_DIRECTORY}/neovim/install.sh" >/dev/null
echo "Neovim configured..."
source "${DOTFILE_DIRECTORY}/window-manager/install.sh" >/dev/null
echo "Window manager configured..."
echo "Ready to go!"

if [ "${CODESPACES}" == "true" ]; then
	echo "Environment setup complete!" | wall
fi
