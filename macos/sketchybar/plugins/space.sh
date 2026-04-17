#!/bin/bash
# $1 = workspace id this item represents
# Runs on aerospace_workspace_change + front_app_switched.
# Updates: (a) pill color via bracket, (b) app icon glyphs next to number

WS="$1"
FOCUSED_WS="${FOCUSED:-$(aerospace list-workspaces --focused)}"

source "$HOME/.config/sketchybar/plugins/icon_map.sh"

# Collect unique app icons for windows on this workspace.
# __icon_map (from sketchybar-app-font) sets $icon_result to a :slug: that the
# sketchybar-app-font ligature renders as a single glyph.
icons=""
seen=""
while IFS= read -r app; do
    [ -z "$app" ] && continue
    case " $seen " in *" $app "*) continue ;; esac
    seen="$seen $app"
    __icon_map "$app"
    icons="$icons $icon_result"
done < <(aerospace list-windows --workspace "$WS" --format '%{app-name}' 2>/dev/null)

icons="${icons# }"

# Colors (Tokyo Night, sourced from shared palette)
source "$HOME/dotfiles/theme/palette.sh"
ACTIVE="0xb3${blue#\#}"
SURFACE="0x99${bg_highlight#\#}"
FG="0xff${fg#\#}"
FG_DIM="0xff${comment#\#}"

if [ "$WS" = "$FOCUSED_WS" ]; then
    BG_COLOR=$ACTIVE
    LABEL_COLOR=$FG
else
    BG_COLOR=$SURFACE
    LABEL_COLOR=$FG_DIM
fi

sketchybar --set "space_bracket.$WS" background.color=$BG_COLOR \
           --set "space.$WS" label.color=$LABEL_COLOR \
           --set "space_apps.$WS" label="$icons" label.color=$LABEL_COLOR
