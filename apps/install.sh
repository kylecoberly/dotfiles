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
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get install -y --no-install-recommends \
		ranger bat htop ncdu nmap tldr tree wget ffmpeg \
		openssh-server xclip build-essential docker-ce docker-ce-cli \
		p7zip rar unrar
elif [[ "$OSTYPE" == "darwin"* ]]; then
	brew install ranger bat htop ncdu nmap tldr tree wget ffmpeg \
		openssh-server docker xsel rar
	brew install --cask firefox chrome alt-tab rectangle
fi

DOTFILES=(.gitconfig .gitignore .aliases .markdownlintrc)
for dotfile in "${DOTFILES[@]}"; do
	rm "${HOME}/${dotfile}"
	ln -sf "${DOTFILE_DIRECTORY}/apps/${dotfile}" "${HOME}/"
done
