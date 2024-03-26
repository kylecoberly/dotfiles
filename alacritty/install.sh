#!/bin/bash

# Depends on Rust (Linux) or Brew (MacOS)

if [ -z "$HOME" ]; then
	exit 1
fi

if [ "${CODESPACES}" == "true" ]; then
	DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
	DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

## Install font
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	mkdir -p ~/.local/share/fonts
	cp "${DOTFILE_DIRECTORY}/alacritty/Noto Mono Nerd Font Complete.ttf" "${HOME/.local/share/fonts/}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	cp "${DOTFILE_DIRECTORY}/alacritty/Noto Mono Nerd Font Complete.ttf" /Library/Fonts
fi

## Build Alacritty
if ! command -v alacritty &>/dev/null; then
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		# sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
		# cargo install alacritty
		sudo apt-get update
		sudo apt-get install alacritty
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		brew install --cask alacritty
	fi
fi

## System Configuration
### Natural Scrolling, tapping
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo rm -rf /etc/X11/xorg.conf.d/40-libinput.conf
	sudo ln -sf "${DOTFILE_DIRECTORY}/alacritty/40-libinput.conf" "/etc/X11/xorg.conf.d/40-libinput.conf"
fi

## Link dotfiles
rm -rf "${HOME}/.config/alacritty"
mkdir -p "${HOME}/.config/alacritty"
ln -sf "${DOTFILE_DIRECTORY}/alacritty/alacritty.yml" "${HOME}/.config/alacritty/alacritty.yml"
ln -sf "${DOTFILE_DIRECTORY}/alacritty/melange.yml" "${HOME}/.config/alacritty/melange.yml"

## ChromeOS and Ubuntu Desktop Icon
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	if [ -d "/usr/share/Applications/desktop" ]; then
		cp -f "${DOTFILE_DIRECTORY}/alacritty/Alacritty.desktop" /usr/share/Applications/desktop/
	fi
fi
