# Emit OSC 7 (file:// URI of cwd) so the local terminal/multiplexer can track
# this shell's working directory. Tmux 3.0+ uses this to set pane_path,
# which the tmux spawn-pane.sh helper reads to re-spawn an ssh connection
# at the same remote folder.
#
# Sourced from .zshrc on every host that has the dotfiles installed; the
# bash branch lets the same file work if sourced from .bashrc. Paths are
# emitted literally (no percent encoding); paths with control characters
# may render imperfectly but tmux tolerates normal Unix paths.

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
