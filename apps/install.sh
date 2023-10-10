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
	## Install Docker
	sudo apt-get update
	sudo apt-get install ca-certificates curl gnupg
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo \
		"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
		"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
		sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	## Install apps
	sudo apt-get install -y --no-install-recommends \
		ranger bat htop ncdu nmap tldr tree wget ffmpeg \
		openssh-server xclip build-essential p7zip rar unrar \
		tidy
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
