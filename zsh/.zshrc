# ─── Options ───────────────────────────────────────────────────────────
setopt extendedglob nocaseglob globdots
setopt hist_ignore_all_dups hist_reduce_blanks share_history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

export VISUAL=nvim
export EDITOR="$VISUAL"
export COLORTERM=truecolor

# ─── PATH / Homebrew (arch-aware) ──────────────────────────────────────
# brew shellenv sets PATH, MANPATH, INFOPATH, HOMEBREW_* correctly for
# whichever install is present (Apple Silicon /opt/homebrew, Intel /usr/local).
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.fly/bin:$PATH"

# ─── Keybindings ───────────────────────────────────────────────────────
bindkey -v                                  # vi-mode
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode
bindkey "\e." insert-last-word              # Alt/Esc-. → last word

# ─── Completion ────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ─── Plugins ───────────────────────────────────────────────────────────
# Order matters: fzf-tab before compinit-dependent plugins,
# syntax-highlighting MUST be sourced LAST.
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── Tool init ─────────────────────────────────────────────────────────
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"          # adds fuzzy ^R, ^T, Alt-C

# ─── Colored man pages ─────────────────────────────────────────────────
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\e[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# ─── Aliases ───────────────────────────────────────────────────────────
[ -f ~/dotfiles/zsh/aliases.zsh ] && source ~/dotfiles/zsh/aliases.zsh
[ -f ~/.aliases ] && source ~/.aliases
