#!/bin/bash

# Symlinks Claude Code user-level config from dotfiles into ~/.claude/.
# Backs up any existing real files to ~/.claude/backups/<timestamp>/ first.

set -e

if [ -z "$HOME" ]; then
	exit 1
fi

if [ "${CODESPACES}" == "true" ]; then
	DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
	DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

CLAUDE_SRC="${DOTFILE_DIRECTORY}/claude"
CLAUDE_DEST="${HOME}/.claude"
BACKUP_DIR="${CLAUDE_DEST}/backups/install-$(date +%Y%m%d-%H%M%S)"

mkdir -p "${CLAUDE_DEST}"

link() {
	local name="$1"
	local src="${CLAUDE_SRC}/${name}"
	local dest="${CLAUDE_DEST}/${name}"

	if [ -L "${dest}" ]; then
		rm "${dest}"
	elif [ -e "${dest}" ]; then
		mkdir -p "${BACKUP_DIR}"
		mv "${dest}" "${BACKUP_DIR}/${name}"
	fi

	ln -s "${src}" "${dest}"
}

link settings.json
link CLAUDE.md
link statusline-command.sh
link commands
link agents
link skills
