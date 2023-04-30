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
	sudo apt-get install -y --no-install-recommends i3
	rm -rf "${HOME}/.config/i3"
	mkdir -p "${HOME}/.config/i3"
	# Fix this directory
	ln -sf "${DOTFILE_DIRECTORY}/window-management/.i3-space" "${HOME}/.i3"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	# Instructions for disabling SIP go here
	brew install --cask yabai spacebar
	rm -rf "${HOME}/.config/spacebar" "${HOME}/.yabairc" "${HOME}/.skhdrc"
	mkdir -p "${HOME}/.config/spacebar"
	# Directory names?
	ln -sf "${DOTFILE_DIRECTORY}/window-management/spacebarrc" "${HOME}/.config/spacebar"
	ln -sf "${DOTFILE_DIRECTORY}/window-management/.yabairc" "${HOME}/.yabairc"
	ln -sf "${DOTFILE_DIRECTORY}/window-management/.skhdrc" "${HOME}/.skhdrc"
fi
