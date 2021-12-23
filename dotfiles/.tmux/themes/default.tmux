# -------------
# Try to get close to normal colors in tmux
# -------------
set-option -g default-terminal "screen-256color"

# -------------
# start with window 1 (instead of 0)
# -------------
set-option -g base-index 1

# -------------
# start with pane 1
# -------------
set-option -g pane-base-index 1

# -------------
# status line
# -------------
#set-option -g status-utf8 on
#set-option -g status-justify left
#set-option -g status-bg colour230
#set-option -g status-fg black
#set-option -g status-interval 4

# -------------
# window status
# -------------
#setw -g window-status-format "#[fg=black]#[bg=colour7] #I #[fg=black]#[bg=colour15] #W "
#setw -g window-status-current-format "#[fg=colour8]#[bg=white] #I #[bg=colour69]#[fg=white] #W "
#setw -g window-status-current-bg black
#setw -g window-status-current-fg yellow
#setw -g window-status-current-attr bold
#setw -g window-status-bg black
#setw -g window-status-fg blue
#setw -g window-status-attr default
#setw -g window-status-content-bg black
#setw -g window-status-content-fg blue
#setw -g window-status-content-attr bold

# -------------
# Info on left (no session display)
# -------------
set -g status-left ''
set -g status-right-length 150
set -g status-right '#[fg=colour69] %m/%d - %l:%M '
#set -g status-utf8 on

# -------------
# Mouse mode on
# -------------
#set -g mouse-utf8 on
set -g mouse on
