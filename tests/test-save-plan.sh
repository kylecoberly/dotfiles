#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "FAIL: $1" >&2; exit 1; }
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

SANDBOX=$("$REPO/tests/sandbox-apply.sh")
HOOK="$SANDBOX/.claude/hooks/save-plan/save-plan.sh"
[ -x "$HOOK" ] || fail "hook missing or not executable in applied tree"

VAULT="$TMP/vault"; mkdir -p "$VAULT"
echo '{"oauthAccount":{"emailAddress":"kyle.coberly@gmail.com"}}' > "$TMP/claude.json"
mkdir -p "$TMP/myproj" && git -C "$TMP/myproj" init -q

printf '{"tool_input":{"plan":"# Test Plan Title\\n\\nBody."},"cwd":"%s"}' "$TMP/myproj" \
  | HOME="$TMP" OBSIDIAN_VAULT="$VAULT" CLAUDE_JSON="$TMP/claude.json" "$HOOK" \
  || fail "hook exited non-zero on happy path"

FILE=$(ls "$VAULT/zz_/plans/personal/myproj/"*-test-plan-title.md) || fail "plan file not written"
grep -q '^account: personal$' "$FILE" || fail "frontmatter missing account"
grep -q '^# Test Plan Title$' "$FILE" || fail "plan body missing"

# no vault → silent no-op, exit 0
printf '{"tool_input":{"plan":"# X"},"cwd":"%s"}' "$TMP" \
  | HOME="$TMP/nohome" OBSIDIAN_VAULT="$TMP/nope" CLAUDE_JSON="$TMP/claude.json" "$HOOK" \
  || fail "missing vault must exit 0"

# empty plan → no file, exit 0
printf '{"cwd":"%s"}' "$TMP/myproj" \
  | HOME="$TMP" OBSIDIAN_VAULT="$VAULT" CLAUDE_JSON="$TMP/claude.json" "$HOOK" \
  || fail "empty plan must exit 0"

echo ok
