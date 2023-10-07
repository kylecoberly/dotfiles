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
plugins=( \
  git git-extras command-not-found common-aliases \
  npm tmux vi-mode zsh-autosuggestions sudo \
  zsh-syntax-highlighting ubuntu docker-compose asdf \
  copyfile history colored-man-pages fancy-ctrl-z \
)

# PATH
export PATH="/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/root/.config/composer/vendor/bin:$PATH"
export PATH="/usr/bin/gradle-6.6.1/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="$HOME/.fly/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_UNICODE=true
ZSH_TMUX_CONFIG="${HOME}/.config/tmux/tmux.conf"
ZSH_TMUX_DEFAULT_SESSION_NAME=Playground

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

## asdf Java
if [[ -d ~/.asdf/plugins/java ]]; then
  . ~/.asdf/plugins/java/set-java-home.zsh
fi
if [[ -d ~/.asdf/plugins/golang ]]; then
	. ~/.asdf/plugins/golang/set-env.zsh
fi
