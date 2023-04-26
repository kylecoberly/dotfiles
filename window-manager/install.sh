#!/bin/bash

# Requires Brew

if [ -z "$HOME" ]; then
	exit 1
fi

if [ "${CODESPACES}" == "true" ]; then
	DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
	DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt update && sudo apt install i3
	mkdir -p "${HOME}/.config/i3"
	rm -f "${HOME}/.config/i3/config"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/i3-config" "${HOME}/.config/i3/config"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	DOTFILES=(.yabairc .skhdrc .spacebarrc)
	for dotfile in "${DOTFILES[@]}"; do
		rm "${HOME}/${dotfile}"
		ln -sf "${DOTFILE_DIRECTORY}/apps/${dotfile}" "${HOME}/"
	done
	brew install koekeishiya/formulae/yabai
	brew services start yabai

	brew install koekeishiya/formulae/skhd
	brew services start skhd
fi
