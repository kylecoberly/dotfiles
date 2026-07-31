#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "FAIL: $1" >&2; exit 1; }
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

source "$REPO/dot_claude/scripts/executable_vault-target.sh"

# account mapping
echo '{"oauthAccount":{"emailAddress":"kcoberly@nsls.org"}}' > "$TMP/claude.json"
[ "$(CLAUDE_JSON=$TMP/claude.json resolve_account)" = "work" ] || fail "work mapping"
echo '{"oauthAccount":{"emailAddress":"kyle.coberly@gmail.com"}}' > "$TMP/claude.json"
[ "$(CLAUDE_JSON=$TMP/claude.json resolve_account)" = "personal" ] || fail "personal mapping"
echo '{"oauthAccount":{"emailAddress":"Someone.Else@Corp.IO"}}' > "$TMP/claude.json"
[ "$(CLAUDE_JSON=$TMP/claude.json resolve_account)" = "someone-else-corp-io" ] || fail "sanitized fallback"
[ "$(CLAUDE_JSON=$TMP/absent.json resolve_account)" = "unknown" ] || fail "missing file → unknown"

# vault resolution
mkdir "$TMP/vault"
[ "$(OBSIDIAN_VAULT=$TMP/vault HOME=$TMP resolve_vault)" = "$TMP/vault" ] || fail "explicit vault wins"
# the /mnt fallback is a real absolute path — on machines that have it
# (Serena) the no-vault and home-fallback branches are unreachable by design
if [ ! -d /mnt/files/application-data/obsidian/notes ]; then
  if OBSIDIAN_VAULT=$TMP/nope HOME=$TMP resolve_vault >/dev/null 2>&1; then fail "no vault should return 1"; fi
  mkdir -p "$TMP/Documents/notes"
  [ "$(OBSIDIAN_VAULT=$TMP/nope HOME=$TMP resolve_vault)" = "$TMP/Documents/notes" ] || fail "home fallback"
fi

# project resolution
mkdir -p "$TMP/proj/sub" && git -C "$TMP/proj" init -q
[ "$(resolve_project "$TMP/proj/sub")" = "proj" ] || fail "git repo basename"
[ "$(HOME=$TMP resolve_project "$TMP")" = "home" ] || fail "cwd == HOME → home"
mkdir -p "$TMP/loose dir"
[ "$(resolve_project "$TMP/loose dir")" = "loose dir" ] || fail "plain cwd basename"

echo ok
