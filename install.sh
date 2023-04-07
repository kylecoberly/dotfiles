#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get update >/dev/null
fi

source zsh/install.sh >/dev/null
echo "Shell configured..."
source apps/install.sh >/dev/null
echo "Apps configured..."
source environments/install.sh >/dev/null
echo "Environments configured..."
source alacritty/install.sh >/dev/null
echo "Alacritty configured"
source tmux/install.sh >/dev/null
echo "TMUX configured..."
source neovim/install.sh >/dev/null
echo "Neovim configured..."
echo "Ready to go!"

if [ "${CODESPACES}" == "true" ]; then
	echo "Environment setup complete!" | wall
fi
