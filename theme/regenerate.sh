#!/usr/bin/env bash
# Regenerate every Tokyo Night palette consumer from theme/palette.sh.
# After editing palette.sh, run: ./theme/regenerate.sh
#
# Updates:
#   dot_config/ghostty/palette          (ghostty, applied by chezmoi)
#   theme/palette.lua                   (neovim helper, read in place)
#   dot_config/starship.toml            (between palette markers only)

set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$THEME_DIR")"

# shellcheck source=palette.sh
source "$THEME_DIR/palette.sh"

# ─── palette (ghostty) ─────────────────────────────────────────────────
# Map TN palette → the 16-color ANSI grid.
# Normal slots use the standard accent values; bright slots reuse the same
# accents (TN doesn't ship distinct bright variants), with bg_dark for
# normal black and a lighter grey for bright black.
cat > "$DOTFILES/dot_config/ghostty/palette" <<EOF
# Tokyo Night — Night variant
# GENERATED from theme/palette.sh by regenerate.sh — do not edit by hand.
background = $bg
foreground = $fg
palette = 0=$bg_dark
palette = 1=$red
palette = 2=$green
palette = 3=$yellow
palette = 4=$blue
palette = 5=$magenta
palette = 6=$cyan
palette = 7=$fg_dark
palette = 8=$fg_gutter
palette = 9=$red
palette = 10=$green
palette = 11=$yellow
palette = 12=$blue
palette = 13=$magenta
palette = 14=$cyan
palette = 15=$fg
EOF

# ─── palette.lua (neovim helper) ───────────────────────────────────────
cat > "$THEME_DIR/palette.lua" <<EOF
-- Tokyo Night — Night variant
-- GENERATED from theme/palette.sh by regenerate.sh — do not edit by hand.

return {
  bg = "$bg",
  bg_dark = "$bg_dark",
  bg_highlight = "$bg_highlight",
  fg = "$fg",
  fg_dark = "$fg_dark",
  fg_gutter = "$fg_gutter",
  comment = "$comment",
  red = "$red",
  orange = "$orange",
  yellow = "$yellow",
  green = "$green",
  teal = "$teal",
  cyan = "$cyan",
  blue = "$blue",
  blue0 = "$blue0",
  magenta = "$magenta",
  purple = "$purple",
}
EOF

# ─── zsh/starship.toml [palettes.tokyonight] block ─────────────────────
# Replaces lines between "# >>> palette ..." and "# <<< palette" markers.
STARSHIP="$DOTFILES/dot_config/starship.toml"
[[ -f "$STARSHIP" ]] || { echo "missing: $STARSHIP" >&2; exit 1; }
grep -q '^# >>> palette' "$STARSHIP" || { echo "missing palette markers in $STARSHIP" >&2; exit 1; }

PALETTE_BLOCK=$(cat <<EOF
# >>> palette (generated from theme/palette.sh — do not edit) >>>
[palettes.tokyonight]
bg = "$bg"
bg_dark = "$bg_dark"
bg_highlight = "$bg_highlight"
fg = "$fg"
fg_dark = "$fg_dark"
comment = "$comment"
red = "$red"
orange = "$orange"
yellow = "$yellow"
green = "$green"
teal = "$teal"
cyan = "$cyan"
blue = "$blue"
blue0 = "$blue0"
magenta = "$magenta"
purple = "$purple"
# <<< palette <<<
EOF
)

{
  in_block=0
  while IFS= read -r line; do
    case "$line" in
      "# >>> palette"*) printf '%s\n' "$PALETTE_BLOCK"; in_block=1; continue ;;
      "# <<< palette"*) in_block=0; continue ;;
    esac
    (( in_block )) || printf '%s\n' "$line"
  done < "$STARSHIP"
} > "$STARSHIP.tmp"
mv "$STARSHIP.tmp" "$STARSHIP"

echo "regenerated:"
echo "  $DOTFILES/dot_config/ghostty/palette"
echo "  $THEME_DIR/palette.lua"
echo "  $STARSHIP (palette block)"
echo "→ run 'chezmoi apply' to propagate to ~/.config."
