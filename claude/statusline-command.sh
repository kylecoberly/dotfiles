#!/usr/bin/env bash
# Claude Code statusLine: two-line — dir+git / model+style+cost+context

input=$(cat)
cwd=$(echo "$input"        | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input"      | jq -r '.model.display_name // "Claude"')
model_id=$(echo "$input"   | jq -r '.model.id // ""')
style=$(echo "$input"      | jq -r '.output_style.name // "default"')
transcript=$(echo "$input" | jq -r '.transcript_path // empty')
cost_usd=$(echo "$input"   | jq -r '.cost.total_cost_usd // 0')

RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
MAGENTA='\033[35m'
RED='\033[31m'

# --- Line 1: directory + git ----------------------------------------------
dir=$(basename "$cwd")
[ -z "$dir" ] && dir="/"

git_part=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

    stat=$(git -C "$cwd" status --porcelain 2>/dev/null)
    modified=$(echo  "$stat" | grep -c '^.M'  || true)
    staged=$(echo    "$stat" | grep -cE '^[AM]' || true)
    untracked=$(echo "$stat" | grep -c '^??'  || true)

    ahead_behind=$(git -C "$cwd" rev-list --left-right --count \
                   HEAD...@{upstream} 2>/dev/null || echo "0 0")
    ahead=$(echo  "$ahead_behind" | awk '{print $1}')
    behind=$(echo "$ahead_behind" | awk '{print $2}')

    dirty=""
    [ "$modified"  -gt 0 ] 2>/dev/null && dirty="${dirty}${modified}●"
    [ "$staged"    -gt 0 ] 2>/dev/null && dirty="${dirty}${staged}✚"
    [ "$untracked" -gt 0 ] 2>/dev/null && dirty="${dirty}${untracked}…"
    [ "$ahead"     -gt 0 ] 2>/dev/null && dirty="${dirty}↑"
    [ "$behind"    -gt 0 ] 2>/dev/null && dirty="${dirty}↓"

    if [ -n "$dirty" ]; then
        git_part=" $(printf "${YELLOW}${BOLD} ${branch} ${dirty}${RESET}")"
    else
        git_part=" $(printf "${GREEN}${BOLD} ${branch}${RESET}")"
    fi
fi

line1=$(printf "${BLUE}${BOLD} %s${RESET}%s" "$dir" "$git_part")

# --- Line 2: model / style / cost / context --------------------------------

model_part=$(printf "${CYAN}🤖 %s${RESET}" "$model")

if [ "$style" = "default" ]; then
    style_part=$(printf "${DIM}🎨 %s${RESET}" "$style")
else
    style_part=$(printf "${MAGENTA}${BOLD}🎨 %s${RESET}" "$style")
fi

cost_display=$(printf "%.2f" "$cost_usd")
if awk -v c="$cost_usd" 'BEGIN{exit !(c < 1)}'; then
    cost_part=$(printf "${DIM}💰 \$%s${RESET}" "$cost_display")
elif awk -v c="$cost_usd" 'BEGIN{exit !(c < 5)}'; then
    cost_part=$(printf "${YELLOW}💰 \$%s${RESET}" "$cost_display")
else
    cost_part=$(printf "${RED}${BOLD}💰 \$%s${RESET}" "$cost_display")
fi

# Context max depends on model — the `[1m]` suffix marks 1M-context Opus.
case "$model_id" in
    *\[1m\]*|*-1m*) context_max=1000000 ;;
    *)              context_max=200000  ;;
esac

ctx_part=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    last_usage=$(tail -500 "$transcript" 2>/dev/null \
                 | jq -c 'select(.message.usage) | .message.usage' 2>/dev/null \
                 | tail -1)

    if [ -n "$last_usage" ]; then
        tokens=$(echo "$last_usage" | jq -r '
            ((.input_tokens             // 0)
           + (.cache_read_input_tokens  // 0)
           + (.cache_creation_input_tokens // 0))')
        pct=$(( tokens * 100 / context_max ))
        k=$(( tokens / 1000 ))

        if   [ "$pct" -lt 50 ]; then
            ctx_part=$(printf "${DIM}📊 %d%% (%dk)${RESET}" "$pct" "$k")
        elif [ "$pct" -lt 80 ]; then
            ctx_part=$(printf "${YELLOW}📊 %d%% (%dk)${RESET}" "$pct" "$k")
        else
            ctx_part=$(printf "${RED}${BOLD}⚠️  %d%% (%dk)${RESET}" "$pct" "$k")
        fi
    fi
fi

line2="${model_part}  ${style_part}  ${cost_part}"
[ -n "$ctx_part" ] && line2="${line2}  ${ctx_part}"

printf "%s\n%s" "$line1" "$line2"
