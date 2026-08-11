#!/usr/bin/env bash
# PostToolUse hook for Write/Edit: mirror superpowers plans and specs into the
# Obsidian vault under zz_/<plans|specs>/<account>/<project>/.
#
# Why this exists alongside save-plan.sh: that hook keys off an ExitPlanMode
# tool call, but the superpowers skills never enter plan mode — writing-plans
# and brainstorming just Write a file into docs/superpowers/. So every plan
# authored that way was repo-only and invisible to /load-plan. This hook keys
# off the destination path instead of the authoring tool, so any route that
# lands a file in those directories gets mirrored.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../scripts/vault-target.sh
source "$SCRIPT_DIR/../../scripts/vault-target.sh"

VAULT=$(resolve_vault) || exit 0

INPUT=$(cat)
SRC=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')
[ -z "$SRC" ] && exit 0
[ -z "$CWD" ] && CWD=$PWD
[[ "$SRC" != /* ]] && SRC="$CWD/$SRC"

case "$SRC" in
  */docs/superpowers/plans/*.md) KIND=plans ;;
  */docs/superpowers/specs/*.md) KIND=specs ;;
  *) exit 0 ;;
esac

# An Edit can fire before the write settles, and a deleted file is not an error.
[ -f "$SRC" ] || exit 0

ACCOUNT=$(resolve_account)
PROJECT=$(resolve_project "$CWD")
DEST_DIR="$VAULT/zz_/$KIND/$ACCOUNT/$PROJECT"
mkdir -p "$DEST_DIR"

# Keep the source basename: superpowers already date-prefixes these, and a
# stable name makes re-syncs update in place instead of piling up copies.
DEST="$DEST_DIR/$(basename "$SRC")"

{
  printf -- '---\n'
  printf 'created: %s\n' "$(date -Iseconds -r "$SRC")"
  printf 'synced: %s\n' "$(date -Iseconds)"
  printf 'cwd: %s\n' "$CWD"
  printf 'account: %s\n' "$ACCOUNT"
  printf 'origin: %s\n' "$SRC"
  printf 'kind: %s\n' "${KIND%s}"
  printf 'source: superpowers\n'
  printf -- '---\n\n'
  cat "$SRC"
} > "$DEST.tmp" && mv "$DEST.tmp" "$DEST"
