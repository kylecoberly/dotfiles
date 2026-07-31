#!/usr/bin/env bash
# Resolve the Obsidian vault, active Claude account slug, and project name.
# Sourced by hooks; executed directly by slash commands
# (prints "<vault> <account> <project>", arg 1 = cwd override).
# Env overrides for tests: OBSIDIAN_VAULT, CLAUDE_JSON.

resolve_vault() {
  if [ -n "${OBSIDIAN_VAULT:-}" ] && [ -d "$OBSIDIAN_VAULT" ]; then
    echo "$OBSIDIAN_VAULT"; return 0
  fi
  if [ -d /mnt/files/application-data/obsidian/notes ]; then
    echo /mnt/files/application-data/obsidian/notes; return 0
  fi
  if [ -d "$HOME/Documents/notes" ]; then
    echo "$HOME/Documents/notes"; return 0
  fi
  return 1
}

resolve_account() {
  local claude_json="${CLAUDE_JSON:-$HOME/.claude.json}"
  local email=""
  if [ -f "$claude_json" ]; then
    email=$(jq -r '.oauthAccount.emailAddress // empty' "$claude_json" 2>/dev/null || true)
  fi
  case "$email" in
    kyle.coberly@gmail.com) echo personal ;;
    kcoberly@nsls.org)      echo work ;;
    "")                     echo unknown ;;
    *) printf '%s' "$email" | tr '[:upper:]' '[:lower:]' \
         | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' ;;
  esac
}

resolve_project() {
  local cwd="${1:-$PWD}" repo_root
  if repo_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null); then
    basename "$repo_root"
  elif [ "$cwd" = "$HOME" ]; then
    echo home
  else
    basename "$cwd"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
  echo "$(resolve_vault) $(resolve_account) $(resolve_project "${1:-$PWD}")"
fi
