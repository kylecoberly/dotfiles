#!/bin/bash

# Depends on Brew (MacOS)

if [ -z "$HOME" ]; then
	exit 1
fi

if [ "${CODESPACES}" == "true" ]; then
	DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
	DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get install -y --no-install-recommends tmux mawk perl sed
elif [[ "$OSTYPE" == "darwin"* ]]; then
	brew install tmux
fi

rm -rf "${HOME}/.config/tmux"
mkdir "${HOME}/.config/tmux"
rm -f "${HOME}/.tmux.conf.local"
ln -sf "${DOTFILE_DIRECTORY}/tmux/.tmux.conf" "${HOME}/.config/tmux/"
ln -sf "${DOTFILE_DIRECTORY}/tmux/.tmux.conf.local" "${HOME}/"
