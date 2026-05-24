#!/usr/bin/env bash
# PostToolUse hook for ExitPlanMode.
# Reads the approved plan from stdin (JSON), writes it as markdown to the
# Obsidian vault under zz_plans/<subfolder>/, where <subfolder> is decided
# by determine_subfolder() below.
set -euo pipefail

# Silently no-op if the vault isn't configured or doesn't exist on this
# machine — better than failing the tool call.
[ -z "${OBSIDIAN_VAULT:-}" ] && exit 0
[ ! -d "$OBSIDIAN_VAULT" ] && exit 0

INPUT=$(cat)
PLAN=$(printf '%s' "$INPUT" | jq -r '.tool_input.plan // empty')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')
[ -z "$PLAN" ] && exit 0
[ -z "$CWD" ] && CWD=$(pwd)

# ─── Subfolder selection ──────────────────────────────────────────────
# Spec (per user):
#   - if $CWD is inside a git repo  → basename of the repo root
#   - if $CWD is exactly /Users/kylecoberly or /home/kylecoberly → "home"
#   - otherwise → basename of $CWD
#
# TODO(user): implement. Echo the chosen subfolder name to stdout.
# Inputs: $CWD (absolute path string)
# Output: a single folder-name (no slashes), echoed to stdout
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
