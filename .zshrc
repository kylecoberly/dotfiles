export ZSH="$HOME/.oh-my-zsh" # Path to your oh-my-zsh installation.

# Global
enable_correction="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy" # Log format
export VISUAL=nvim
export EDITOR="$VISUAL"
export LANG="en_US.UTF-8"

# Theme
ZSH_THEME="coberly-gruvbox"
SOLARIZED_THEME="dark"
COLORTERM=truecolor

# Plugins
plugins=(git git-extras command-not-found common-aliases npm tmux vi-mode zsh-autosuggestions zsh-syntax-highlighting)

# PATH
export PATH="/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
export PATH="${HOME}/.local/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/root/.config/composer/vendor/bin:$PATH"
export PATH="/usr/bin/gradle-6.6.1/bin:$PATH"
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# Search
bindkey '^R' history-incremental-search-backward # Search
setopt extendedglob nocaseglob globdots

# Vim Mode
bindkey -v # Enable vim mode
bindkey -M viins 'jj' vi-cmd-mode # Go to normal with jj
bindkey -M viins 'jk' vi-cmd-mode # Go to normal with jk

# Bootstrap
source $ZSH/oh-my-zsh.sh

# Shortcuts
source ~/.aliases
bindkey "\e." insert-last-word

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use node

if [[ ! -v TMUX ]]; then
  tmux
fi
