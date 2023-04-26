#!/bin/bash

# IMPORTANT: For MacOS, disable SIP first: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
# On Intel: Hold command-R while booting. Go to "Utilities" → "Terminal" to open bash, then run `csrutil disable --with kext --with dtrace --with nvram --with basesystem`. Reboot.
# After reboot, run `sudo visudo -f /private/etc/sudoers.d/yabai` to add Yabai to sudoers and add the following line:
# <output of `whoami`> ALL=(root) NOPASSWD: sha256:<output of `shasum -a 256 $(which yabai)`> <output of `which yabai`> --load-sa
# For example:
# kylecoberly ALL=(root) NOPASSWD: sha256:740b9e6aab46f8c499f0fc651ae1861d4ebe48b6e6a50296bf4a9ad879bbad93 /usr/local/bin/yabai --load-sa

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
		ln -sf "${DOTFILE_DIRECTORY}/window-manager/${dotfile}" "${HOME}/"
	done

	brew install koekeishiya/formulae/yabai
	brew services start yabai

	brew install koekeishiya/formulae/skhd
	brew services start skhd

	brew install cmacrae/formulae/spacebar
	brew services start spacebar
fi
