#!/usr/bin/env bash
# Top-level entrypoint. Runs shared setup, then the platform-specific script.
set -euo pipefail

INSTALL_LANGUAGES=0
for arg in "$@"; do
  case "$arg" in
    --with-languages|-l)
      INSTALL_LANGUAGES=1
      ;;
    --help|-h)
      cat <<'EOF'
Usage: install.sh [--with-languages]

  --with-languages, -l   After base setup, install every tool listed in
                         ~/.tool-versions via mise, and promote them to
                         ~/.config/mise/config.toml so they resolve from
                         any working directory (mise's per-directory
                         config discovery does not auto-find ~/.tool-versions
                         outside of $HOME).
  --help, -h             Show this help message.
EOF
      exit 0
      ;;
    *)
      echo "Unknown arg: $arg (try --help)" >&2
      exit 1
      ;;
  esac
done

if [ -z "${HOME:-}" ]; then
  echo "HOME not set" >&2
  exit 1
fi

if [ "${CODESPACES:-}" = "true" ]; then
  DOTFILES="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  DOTFILES="${HOME}/dotfiles"
fi
export DOTFILES

echo "→ shared configuration"
source "$DOTFILES/shared/install.sh"

case "$OSTYPE" in
  darwin*)
    echo "→ macOS configuration"
    source "$DOTFILES/macos/install.sh"
    ;;
  linux-gnu*)
    echo "→ Linux configuration"
    source "$DOTFILES/linux/install.sh"
    ;;
  *)
    echo "Unknown OSTYPE: $OSTYPE — skipping platform install" >&2
    ;;
esac

# ─── Optional: install + globalize languages ──────────────────────────
# mise was installed by the platform script and ~/.tool-versions was
# symlinked in shared/install.sh, so by here both are in place.
if [ "$INSTALL_LANGUAGES" = "1" ]; then
  echo "→ installing languages from ~/.tool-versions"
  if ! command -v mise >/dev/null 2>&1; then
    echo "mise not found on PATH after platform install — skipping" >&2
  else
    # mise's config discovery walks UP from CWD; ~/.tool-versions is
    # only seen inside $HOME. cd in so `mise install` picks it up.
    (cd "$HOME" && mise install)

    # Mirror tool-versions into the canonical global TOML so resolved
    # versions work from any directory (e.g. /srv, /opt, repos outside
    # $HOME). `mise use -g` writes ~/.config/mise/config.toml.
    mapfile -t MISE_TOOLS < <(
      awk 'NF >= 2 && $1 !~ /^#/ { print $1 "@" $2 }' "$HOME/.tool-versions"
    )
    if [ "${#MISE_TOOLS[@]}" -gt 0 ]; then
      mise use -g "${MISE_TOOLS[@]}"
    fi
  fi
fi

echo "✓ Ready to go"
