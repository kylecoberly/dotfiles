#!/usr/bin/env bash
# PostToolUse hook for ExitPlanMode.
# Reads the approved plan from stdin (JSON), writes it as markdown to the
# Obsidian vault under zz_plans/<subfolder>/, where <subfolder> is decided
# by determine_subfolder() below.
set -euo pipefail

# Claude Code spawns hooks directly (not via a shell), so .zshrc may not
# have run in the parent. Fall back to the same platform defaults .zshrc
# uses, so the hook works regardless of launch context.
if [ -z "${OBSIDIAN_VAULT:-}" ]; then
  if [ -d /mnt/files/application-data/obsidian/notes ]; then
    OBSIDIAN_VAULT="/mnt/files/application-data/obsidian/notes"
  else
    OBSIDIAN_VAULT="$HOME/Documents/notes"
  fi
fi
# Silently no-op if the resolved vault doesn't exist — better than failing
# the tool call on a machine without a vault.
[ ! -d "$OBSIDIAN_VAULT" ] && exit 0

INPUT=$(cat)
PLAN=$(printf '%s' "$INPUT" | jq -r '.tool_input.plan // empty')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')
[ -z "$PLAN" ] && exit 0
[ -z "$CWD" ] && CWD=$(pwd)

determine_subfolder() {
  local cwd="$1"
  local repo_root
  if repo_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null); then
    basename "$repo_root"
  elif [ "$cwd" = "$HOME" ]; then
    echo "home"
  else
    basename "$cwd"
  fi
}

SUBFOLDER=$(determine_subfolder "$CWD")
PLANS_DIR="$OBSIDIAN_VAULT/zz_plans/$SUBFOLDER"
mkdir -p "$PLANS_DIR"

# Filename: sortable timestamp + slug from first markdown heading (or first
# non-empty line). Collisions across same-second saves are vanishingly rare
# for human-paced plan approvals, so no counter suffix.
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
TITLE=$(printf '%s\n' "$PLAN" | grep -m1 '^#' | sed 's/^#\+ *//' || true)
[ -z "$TITLE" ] && TITLE=$(printf '%s\n' "$PLAN" | grep -m1 '[^[:space:]]' || true)
SLUG=$(printf '%s' "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' \
  | cut -c1-60)
[ -z "$SLUG" ] && SLUG="plan"

FILE="$PLANS_DIR/${TIMESTAMP}-${SLUG}.md"
{
  printf -- '---\n'
  printf 'created: %s\n' "$(date -Iseconds)"
  printf 'cwd: %s\n' "$CWD"
  printf 'source: claude-code\n'
  printf -- '---\n\n'
  printf '%s\n' "$PLAN"
} > "$FILE"
