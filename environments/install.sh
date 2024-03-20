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

## Install dependencies
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get install -y --no-install-recommends git curl jq
elif [[ "$OSTYPE" == "darwin"* ]]; then
	xcode-select --install
	brew install jq
fi

## Install asdf
if [[ "$OSTYPE" == "linux-gnu"* ]] && [ ! -d "$HOME/.asdf" ]; then
	git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf"
	chmod u+x "$HOME/.asdf/asdf.sh"
	sh -c "$HOME/.asdf/asdf.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	brew install asdf coreutils
fi

## Link dotfile
rm "${HOME}/.tool-versions"
touch "${HOME}/.tool-versions"
rm "${HOME}/.asdfrc"
ln -sf "${DOTFILE_DIRECTORY}/environments/.asdfrc" "${HOME}/.asdfrc"

## Install all of the languages in languages.json and write .tool-versions
for language in $(cat "$DOTFILE_DIRECTORY/environments/languages.json" | jq -r '.languages[] | @base64'); do
	get() {
		property=$1
		echo "${language}" | base64 --decode | jq -r "${property}"
	}

	ubuntu_dependencies=$(get '.ubuntu_dependencies')
	mac_dependencies=$(get '.mac_dependencies')
	repo=$(get '.repo')
	target=$(get '.target')
	command=$(get '.command')
	version=$(get '.version')

	if ! command -v "${command}" &>/dev/null; then
		if [[ "$OSTYPE" == "linux-gnu"* ]]; then
			sudo apt-get install -y --no-install-recommends $ubuntu_dependencies
		elif [[ "$OSTYPE" == "darwin"* ]]; then
			brew install $mac_dependencies
		fi
		asdf plugin add "${target}" "${repo}"
		asdf install "${target}" "${version}"
		asdf global "${target}" "${version}"
	fi

	echo "$target $version" >>"${HOME}/.tool-versions"
done
