#!/usr/bin/env bash
# Run a tmux new-window / split-window action. If the source pane is running
# ssh (or mosh), re-spawn that command in the new pane so the new shell lands
# on the same remote host. Otherwise, open the pane at the source pane's
# local cwd.
#
# Remote cwd preservation requires the remote shell to emit OSC 7 (sourced
# from shared/zsh/osc7.zsh via .zshrc on every dotfiles-installed host).
# Tmux exposes the remote path via pane_path as a "file://host/path" URI;
# we parse it and cd to that path after re-establishing ssh. When OSC 7
# isn't set up on a remote, pane_path is empty and we just re-run ssh
# (lands in remote $HOME — same as before this feature).
#
# Usage: spawn-pane.sh <verb> <pane_pid> <pane_current_path> <pane_path>
#   verb: "new-window" | "split-h" | "split-v"

set -eu

verb="$1"
pane_pid="$2"
pane_local_path="$3"
pane_path_uri="${4:-}"

# Walk descendants of $pane_pid (BFS via pgrep -P); return argv of the
# deepest ssh / mosh-client process, if any.
find_remote_cmd() {
  local frontier="$pane_pid" found="" next pid base argv
  while [ -n "$frontier" ]; do
    next=""
    for pid in $frontier; do
      argv=$(ps -o command= -p "$pid" 2>/dev/null || true)
      [ -z "$argv" ] && continue
      base="${argv%% *}"
      base="${base##*/}"
      case "$base" in
        ssh|mosh-client) found="$argv" ;;
      esac
      next="$next $(pgrep -P "$pid" 2>/dev/null || true)"
    done
    frontier="$next"
  done
  printf '%s' "$found"
}

# Extract the path component from a file:// URI: "file://host/path" → "/path".
# Empty / non-file URI → empty.
parse_remote_path() {
  local uri="$1" no_scheme
  case "$uri" in
    file://*)
      no_scheme="${uri#file://}"
      case "$no_scheme" in
        */*) printf '/%s' "${no_scheme#*/}" ;;
        *)   printf '/' ;;
      esac
      ;;
    *) printf '' ;;
  esac
}

remote_cmd=$(find_remote_cmd)

case "$verb" in
  new-window) tmux_cmd="new-window" ;;
  split-h)    tmux_cmd="split-window -h" ;;
  split-v)    tmux_cmd="split-window -v" ;;
  *) echo "spawn-pane.sh: unknown verb '$verb'" >&2; exit 1 ;;
esac

if [ -n "$remote_cmd" ]; then
  first="${remote_cmd%% *}"
  rest="${remote_cmd#* }"
  base="${first##*/}"
  remote_path=$(parse_remote_path "$pane_path_uri")
  if [ "$base" = "ssh" ] && [ "$rest" != "$remote_cmd" ]; then
    if [ -n "$remote_path" ]; then
      inner="cd $(printf %q "$remote_path") 2>/dev/null; exec \$SHELL -il"
      # shellcheck disable=SC2086
      tmux $tmux_cmd "$first -t $rest $(printf %q "$inner")"
    else
      # No OSC 7 path available; just re-run ssh and let it land in $HOME.
      # shellcheck disable=SC2086
      tmux $tmux_cmd "$remote_cmd"
    fi
  else
    # mosh-client (or unusual ssh argv); re-run unchanged.
    # shellcheck disable=SC2086
    tmux $tmux_cmd "$remote_cmd"
  fi
else
  # shellcheck disable=SC2086
  tmux $tmux_cmd -c "$pane_local_path"
fi
