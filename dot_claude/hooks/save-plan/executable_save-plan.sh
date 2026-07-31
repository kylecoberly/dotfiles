#!/usr/bin/env bash
# PostToolUse hook for ExitPlanMode: file the approved plan into the
# Obsidian vault under zz_/plans/<account>/<project>/.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../scripts/executable_vault-target.sh
source "$SCRIPT_DIR/../../scripts/vault-target.sh"

VAULT=$(resolve_vault) || exit 0

INPUT=$(cat)
PLAN=$(printf '%s' "$INPUT" | jq -r '.tool_input.plan // empty')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')
[ -z "$PLAN" ] && exit 0
[ -z "$CWD" ] && CWD=$PWD

ACCOUNT=$(resolve_account)
PROJECT=$(resolve_project "$CWD")
PLANS_DIR="$VAULT/zz_/plans/$ACCOUNT/$PROJECT"
mkdir -p "$PLANS_DIR"

TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
TITLE=$(printf '%s\n' "$PLAN" | grep -m1 '^#' | sed 's/^#\+ *//' || true)
[ -z "$TITLE" ] && TITLE=$(printf '%s\n' "$PLAN" | grep -m1 '[^[:space:]]' || true)
SLUG=$(printf '%s' "$TITLE" | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' | cut -c1-60)
[ -z "$SLUG" ] && SLUG="plan"

{
  printf -- '---\n'
  printf 'created: %s\n' "$(date -Iseconds)"
  printf 'cwd: %s\n' "$CWD"
  printf 'account: %s\n' "$ACCOUNT"
  printf 'source: claude-code\n'
  printf -- '---\n\n'
  printf '%s\n' "$PLAN"
} > "$PLANS_DIR/${TIMESTAMP}-${SLUG}.md"
