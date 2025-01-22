#!/bin/bash

if [ -z "$HOME" ]; then
	exit 1
fi

if [ "${CODESPACES}" == "true" ]; then
	DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
	DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

## Install Brew on MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
	brew install ranger bat htop ncdu nmap tldr tree wget ffmpeg \
		docker xsel rar p7zip awk iproute2mac grep
	brew install --cask firefox
fi

DOTFILES=(.gitconfig .gitignore .aliases .markdownlintrc)
for dotfile in "${DOTFILES[@]}"; do
	rm "${HOME}/${dotfile}"
	ln -sf "${DOTFILE_DIRECTORY}/apps/${dotfile}" "${HOME}/"
done
