#!/usr/bin/env bash
# Print " <branch>" for the given path, or nothing if not a git repo.
# Called from tmux-nova on every status-interval tick, so stay cheap.

set -u

path="${1:-$PWD}"
[[ -d "$path" ]] || exit 0

branch=$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
[[ -n "$branch" ]] || exit 0

# Uncommitted line stats: working tree + index vs HEAD. Falls back silently
# in a fresh repo with no commits yet.
stats=$(git -C "$path" diff HEAD --shortstat 2>/dev/null || true)
added=$(sed -n 's/.* \([0-9][0-9]*\) insertion.*/\1/p' <<<"$stats")
deleted=$(sed -n 's/.* \([0-9][0-9]*\) deletion.*/\1/p' <<<"$stats")
suffix=""
[[ -n "$added"   ]] && suffix+=" +$added"
[[ -n "$deleted" ]] && suffix+=" -$deleted"

# Leading char is U+E0A0 (nerd-fonts git-branch glyph)
printf ' \xee\x82\xa0 %s%s' "$branch" "$suffix"
