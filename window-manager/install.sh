#!/bin/bash

# IMPORTANT: For MacOS, disable SIP first: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
# On Intel: Hold command-R while booting. Go to "Utilities" → "Terminal" to open bash, then run `csrutil disable --with kext --with dtrace --with nvram --with basesystem`. Reboot.
# After reboot, run `sudo visudo -f /private/etc/sudoers.d/yabai` to add Yabai to sudoers and add the following line:
# <output of `whoami`> ALL=(root) NOPASSWD: sha256:<output of `shasum -a 256 $(which yabai)`> <output of `which yabai`> --load-sa
# For example:
# kylecoberly ALL=(root) NOPASSWD: sha256:740b9e6aab46f8c499f0fc651ae1861d4ebe48b6e6a50296bf4a9ad879bbad93 /usr/local/bin/yabai --load-sa

# Requires Brew and NotoMono Nerd Font

if [ -z "$HOME" ]; then
	exit 1
fi

if [ "${CODESPACES}" == "true" ]; then
	DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
	DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt update && sudo apt install -y --no-install-recommends i3 flameshot nitrogen picom rofi dunst playerctl network-manager-gnome libnotify-bin pavucontrol light acpi
	playerctld daemon

	# Keybindings
	rm -f "${HOME}/.Xmodmap"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/.Xmodmap" "${HOME}/.Xmodmap"

	rm -rf $HOME/.config/{i3,dunst/dunstrc,rofi/config.rasi,polybar}
	mkdir -p $HOME/.config/{dunst,rofi}
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/i3" "${HOME}/.config/i3"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/dunstrc" "${HOME}/.config/dunst/dunstrc"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/rofi-config.rasi" "${HOME}/.config/rofi/config.rasi"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/polybar" "${HOME}/.config/polybar"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	DOTFILES=(.yabairc .skhdrc .simplebarrc)
	for dotfile in "${DOTFILES[@]}"; do
		rm "${HOME}/${dotfile}"
		ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/${dotfile}" "${HOME}/"
	done
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/alt-tab.plist" "${HOME}/Library/Preferences/com.lwouis.alt-tab-macos.plist"

	brew install koekeishiya/formulae/yabai
	brew services start yabai

	brew install koekeishiya/formulae/skhd
	brew services start skhd

	brew install --cask ubersicht
	git clone https://github.com/Jean-Tinland/simple-bar "$HOME/Library/Application\ Support/Übersicht/widgets/simple-bar"
	# Activate Simple Bar manually in spotlight now
	brew install --cask karabiner-elements
	brew install --cask alt-tab
fi
