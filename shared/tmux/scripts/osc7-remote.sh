# Emit OSC 7 (file:// URI of cwd) so the local terminal/multiplexer can track
# the remote shell's working directory. Tmux 3.0+ uses this to update
# pane_path for ssh panes, which spawn-pane.sh reads to re-spawn the
# connection at the same remote folder.
#
# Install on each remote host: source this file from ~/.bashrc or ~/.zshrc.
#
# Works in bash, zsh, and POSIX sh. Paths are emitted literally (no percent
# encoding); paths with control characters or unusual bytes may render
# imperfectly but tmux tolerates it for normal Unix paths.

osc7_cwd() {
  printf '\033]7;file://%s%s\033\\' "${HOSTNAME:-$(hostname)}" "$PWD"
}

if [ -n "${ZSH_VERSION:-}" ]; then
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd  osc7_cwd
  add-zsh-hook precmd osc7_cwd
elif [ -n "${BASH_VERSION:-}" ]; then
  case "${PROMPT_COMMAND:-}" in
    *osc7_cwd*) ;;
    *) PROMPT_COMMAND="osc7_cwd${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
  esac
fi

osc7_cwd
