#!/usr/bin/env bash
# Print " <branch>" for the given path, or nothing if not a git repo.
# Called from tmux-nova on every status-interval tick, so stay cheap.

set -u

path="${1:-$PWD}"
[[ -d "$path" ]] || exit 0

branch=$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
[[ -n "$branch" ]] || exit 0

# Leading char is U+E0A0 (nerd-fonts git-branch glyph)
printf ' \xee\x82\xa0 %s' "$branch"
