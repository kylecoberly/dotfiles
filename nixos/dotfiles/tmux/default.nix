{ config, lib, pkgs, ... }:

{
  xdg.configFile = {
    "tmux/tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/tmux.conf";
      recursive = true;
    };
    "tmux/tmux.conf.local" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/tmux/tmux.conf.local";
      recursive = true;
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    secureSocket = true;
    aggressiveResize = true;
    disableConfirmationPrompt = true;
    newSession = true;
    shell = "\${pkgs.zsh}/bin/zsh";
    plugins = with pkgs; [
      tmuxPlugins.yank
      # tmuxPlugins.tmux-which-key
      tmuxPlugins.power-theme
      tmuxPlugins.open
      tmuxPlugins.mode-indicator
      tmuxPlugins.gruvbox
      tmuxPlugins.cpu
      tmuxPlugins.copycat
      {
        plugin = tmuxPlugins.tmux-nova;
        extraConfig = ''
### Separators
set -g @nova-nerdfonts true
set -g @nova-nerdfonts-left \uE0B0
set -g @nova-nerdfonts-right \uE0B2

set -g @nova-pane "#I #W"
set -g @nova-rows 0

### Colors - Melange
fg="#ECE1D7"

black="#292522"
grey="#34302C"

red="#7D2A2F"
yellow="#EBC06D"
orange="#D47766"
green="#85B695"
aqua="#89B3B6"
blue="#7F91B2"
purple="#B380B0"

seg_a="$green $grey"
seg_b="$grey $fg"

set -g "@nova-status-style-bg" "$grey"
set -g "@nova-status-style-fg" "$fg"
set -g "@nova-status-style-active-bg" "$fg"
set -g "@nova-status-style-active-fg" "$grey"

set -g "@nova-pane-active-border-style" "$blue"
set -g "@nova-pane-border-style" "$orange"

### Status Bar
set -g @nova-segment-prefix "#{?client_prefix,PREFIX,}"
set -g @nova-segment-prefix-colors "$seg_b"

set -g @nova-segment-session "#{session_name}"
set -g @nova-segment-session-colors "$seg_a"

set -g @nova-segment-cpu " #(~/.tmux/plugins/tmux-cpu/scripts/cpu_percentage.sh) #(~/.tmux/plugins/tmux-cpu/scripts/ram_percentage.sh)"
set -g @nova-segment-cpu-colors "$seg_b"

set -g @nova-segments-0-left "session"
set -g @nova-segments-0-right "prefix cpu layout"
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
set -g @continuum-save-interval '5'
set -g @continuum-restore 'on'
set -g @continuum-boot 'on'
        '';
      }
    ];
  };
}
