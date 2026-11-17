# peon-ping quick controls
alias peon="bash $HOME/.claude/hooks/peon-ping/peon.sh"
[ -f $HOME/.claude/hooks/peon-ping/completions.bash ] && source $HOME/.claude/hooks/peon-ping/completions.bash

# NSLS work sessions run in their own CLAUDE_CONFIG_DIR, not ~/.claude. The org
# toolkit reports every skill call to an NSLS tracker keyed on the account's
# email, so binding the toolkit to a config dir is what keeps work telemetry off
# the personal account — enabling the plugin globally does not.
claude-nsls() {
  if [ ! -d "$HOME/.claude-nsls" ]; then
    echo "claude-nsls: no ~/.claude-nsls on $(hostname -s) — the NSLS toolkit is Mac-only." >&2
    return 1
  fi
  CLAUDE_CONFIG_DIR="$HOME/.claude-nsls" command claude "$@"
}
