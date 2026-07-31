#!/usr/bin/env bash
# Apply the repo's chezmoi source into a throwaway destination and print it.
# Excludes run_ scripts (no package installs) and externals (no network).
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX="${1:-$(mktemp -d)}"
chezmoi apply --source "$REPO" --destination "$SANDBOX" \
  --exclude scripts,externals --force >/dev/null
echo "$SANDBOX"
