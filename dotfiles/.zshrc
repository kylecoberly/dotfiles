# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="coberly-gruvbox"
SOLARIZED_THEME="dark"
COLORTERM=truecolor

# uncomment the following line to enable command auto-correction.
# enable_correction="true"
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-extras command-not-found common-aliases npm tmux vi-mode)

# User configuration

# PATH
export PATH="/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
export PATH="${HOME}/.local/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/root/.config/composer/vendor/bin:$PATH"
export PATH="/usr/bin/gradle-6.6.1/bin:$PATH"

# Oh-My-ZSH
source $ZSH/oh-my-zsh.sh

# shell
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^R' history-incremental-search-backward
setopt extendedglob nocaseglob globdots
export VISUAL=nvim
export EDITOR="$VISUAL"
export LANG="en_US.UTF-8"
bindkey "\e." insert-last-word

# Aliases
source ~/.aliases

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
source ~/.rvm/scripts/rvm
