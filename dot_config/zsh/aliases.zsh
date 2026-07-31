# ─── Shortcuts ─────────────────────────────────────────────────────────
alias c='clear'
alias ll='ls -lGhp --group-directories-first --color=always | awk "{print \$1,\$3,\$4,\$8}" | column -t'
alias lsa='ls -lAGhp --group-directories-first --color=always | awk "{print \$1,\$3,\$4,\$8}" | column -t'

# ─── Overrides ─────────────────────────────────────────────────────────
alias vi='nvim'
alias vim='nvim'
alias top='htop'
alias du='ncdu --color dark -rr -x --exclude .git --exclude node_modules'
alias ranger='ranger --choosedir=$HOME/rangerdir; LASTDIR=$(cat $HOME/rangerdir); rm -f $HOME/rangerdir; cd "$LASTDIR"'
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias cat='batcat'
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias cat='bat'
fi

# ─── Git (subset of oh-my-zsh git plugin) ──────────────────────────────
alias g='git'
alias gst='git status'
alias gss='git status -s'
alias ga='git add'
alias gaa='git add --all'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gbd='git branch -d'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias gm='git merge'
alias gsta='git stash push'
alias gstp='git stash pop'
alias gstl='git stash list'
alias grh='git reset'
alias grhh='git reset --hard'
alias gcl='git clone'
alias gcp='git cherry-pick'

# ─── eza (modern ls) ───────────────────────────────────────────────────
alias la='eza -la --git --group-directories-first'
alias lt='eza --tree --level=2 --git-ignore'
alias lta='eza --tree --level=3'

# ─── Functions ─────────────────────────────────────────────────────────
# Show what's listening on every TCP port (macOS).
ports() {
  sudo lsof -iTCP -sTCP:LISTEN -n -P \
    | awk 'NR>1 {print $9, $1, $2}' \
    | sed 's/.*://' \
    | while read port process pid; do
        echo "Port $port: $(ps -p $pid -o command= | sed 's/^-//') (PID: $pid)"
      done \
    | sort -n
}

untar() { tar -zxvf "$1"; }
