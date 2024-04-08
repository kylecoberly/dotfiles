#!/bin/bash

# IMPORTANT: For MacOS, disable SIP first: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
# On Intel: Hold command-R while booting. Then, go to "Utilities" → "Terminal" to open bash, then run `csrutil disable --with kext --with dtrace --with nvram --with basesystem`. Reboot.
# On Apple Silicon: Press and hold the power button on your Mac until “Loading startup options” appears. Click Options, then click Continue.
#   Run `csrutil enable --without fs --without debug --without nvram`. Reboot. Run `sudo nvram boot-args=-arm64e_preview_abi`.
# After reboot, run `sudo visudo -f /private/etc/sudoers.d/yabai` to add Yabai to sudoers and add the following line:
# <output of `whoami`> ALL=(root) NOPASSWD: sha256:<output of `shasum -a 256 $(which yabai)`> <output of `which yabai`> --load-sa
# For example:
# kylecoberly ALL=(root) NOPASSWD: sha256:740b9e6aab46f8c499f0fc651ae1861d4ebe48b6e6a50296bf4a9ad879bbad93 /usr/local/bin/yabai --load-sa

# For MacOS, put Ubersicht in System Preferences → Users & Groups → Login Items to make it launch simple-bar on startup
# You'll also need to put `macos/startup.sh` in there

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
	sudo apt-get update && sudo apt-get install -y --no-install-recommends i3 flameshot nitrogen picom rofi dunst playerctl network-manager-gnome libnotify-bin pavucontrol light acpi alttab polybar autorandr blueman luarocks vlc p7zip
	playerctld daemon

	# Keybindings
	rm -f "${HOME}/.Xmodmap"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/.Xmodmap" "${HOME}/.Xmodmap"

	rm -rf $HOME/.config/{i3,dunst/dunstrc,rofi/config.rasi,polybar}
	mkdir -p $HOME/.config/{dunst,rofi}
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/i3" "${HOME}/.config/i3"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/dunstrc" "${HOME}/.config/dunst/dunstrc"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/rofi/config.rasi" "${HOME}/.config/rofi/config.rasi"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/ubuntu/polybar" "${HOME}/.config/polybar"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	DOTFILES=(.yabairc .skhdrc)
	for dotfile in "${DOTFILES[@]}"; do
		rm "${HOME}/${dotfile}"
		ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/${dotfile}" "${HOME}/"
	done
	# simple-bar config
	rm "${HOME}/.simplebarrc"
	if [[ $(uname -p) == 'arm' ]]; then
		ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/.simplebarrc-m1" "${HOME}/.simplebarrc"
	else
		ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/.simplebarrc-intel" "${HOME}/.simplebarrc"
	fi
	rm "${HOME}/.config/karabiner/karabiner.json"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/alt-tab.plist" "${HOME}/Library/Preferences/com.lwouis.alt-tab-macos.plist"

	# Stop Dock icon bouncing
	defaults write com.apple.dock no-bouncing -bool TRUE
	killall Dock
 	# Show hidden files by default
 	defaults write com.apple.Finder AppleShowAllFiles true

	brew install koekeishiya/formulae/yabai
	yabai --start-service

	brew install koekeishiya/formulae/skhd
	skhd --start-service
	brew install --cask ubersicht
	git clone https://github.com/Jean-Tinland/simple-bar "$HOME/Library/Application Support/Übersicht/widgets/simple-bar"
	# Activate Simple Bar manually in spotlight now
	brew install --cask karabiner-elements
	brew install --cask alt-tab

	# Add borders for Yabai
	brew tap FelixKratz/formulae
	brew install borders
fi
