#!/bin/bash

# macOS: uses aerospace (tiling WM, no SIP needed) + sketchybar (status bar).
# Aerospace auto-starts via `start-at-login = true` in its config — no LaunchAgent.
# Requires Brew and a Nerd Font (Hack Nerd Font used by sketchybar).

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
	# aerospace config (TOML)
	rm -f "${HOME}/.aerospace.toml"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/.aerospace.toml" "${HOME}/.aerospace.toml"

	# sketchybar config
	mkdir -p "${HOME}/.config"
	rm -rf "${HOME}/.config/sketchybar"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/sketchybar" "${HOME}/.config/sketchybar"

	# karabiner + alt-tab (independent of window manager)
	mkdir -p "${HOME}/.config/karabiner"
	rm -f "${HOME}/.config/karabiner/karabiner.json"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/alt-tab.plist" "${HOME}/Library/Preferences/com.lwouis.alt-tab-macos.plist"

	# Stop Dock icon bouncing
	defaults write com.apple.dock no-bouncing -bool TRUE
	# Group Mission Control windows by app (fixes aerospace off-screen windows appearing in a cramped corner)
	defaults write com.apple.dock expose-group-apps -bool true
	# Speed up Mission Control / Expose animation
	defaults write com.apple.dock expose-animation-duration -float 0.1
	# Disable window animations — makes aerospace workspace switches feel instant
	defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
	# Near-instant window resize animation
	defaults write -g NSWindowResizeTime -float 0.001
	killall Dock
	# Show hidden files by default
	defaults write com.apple.Finder AppleShowAllFiles true

	# Window manager
	brew install --cask nikitabobko/tap/aerospace

	# Status bar — sketchybar, built from source so it works with older Xcode.
	# Latest sketchybar (>=2.17.1) requires newer macOS SDK symbols; v2.16.4 is
	# the last release that builds with Xcode 14.2 / macOS SDK 13.
	if ! command -v sketchybar >/dev/null 2>&1; then
		SB_BUILD="$(mktemp -d)"
		git clone --depth=1 --branch v2.16.4 https://github.com/FelixKratz/SketchyBar.git "${SB_BUILD}/SketchyBar"
		(cd "${SB_BUILD}/SketchyBar" && make)
		cp "${SB_BUILD}/SketchyBar/bin/sketchybar" /usr/local/bin/sketchybar
		chmod +x /usr/local/bin/sketchybar
		rm -rf "${SB_BUILD}"
	fi

	# Sketchybar LaunchAgent (auto-start at login; KeepAlive on crash)
	mkdir -p "${HOME}/Library/LaunchAgents"
	rm -f "${HOME}/Library/LaunchAgents/org.felixkratz.sketchybar.plist"
	ln -sf "${DOTFILE_DIRECTORY}/window-manager/macos/sketchybar/org.felixkratz.sketchybar.plist" \
		"${HOME}/Library/LaunchAgents/org.felixkratz.sketchybar.plist"
	launchctl bootout "gui/$(id -u)/org.felixkratz.sketchybar" 2>/dev/null || true
	launchctl bootstrap "gui/$(id -u)" "${HOME}/Library/LaunchAgents/org.felixkratz.sketchybar.plist"

	# Audio device switching (used by sketchybar's sound widget)
	brew install switchaudio-osx

	# Supporting apps
	brew install --cask karabiner-elements
	brew install --cask alt-tab
fi
