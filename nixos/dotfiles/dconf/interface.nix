# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 3;
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      color-scheme = "prefer-dark";
      cursor-theme = "Adwaita";
      enable-animations = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Ubuntu 11";
      gtk-theme = "Adwaita";
      icon-theme = "Adwaita";
      locate-pointer = true;
      show-battery-percentage = true;
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
      dynamic-workspaces = false;
      experimental-features = [];
      workspaces-only-on-primary = true;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [ ];
      enabled-extensions = [ "just-perfection-desktop@just-perfection" "ubuntu-dock@ubuntu.com" "ubuntu-appindicators@ubuntu.com" ];
      favorite-apps = [ "org.gnome.Nautilus.desktop" "Zoom.desktop" "google-chrome.desktop" "Alacritty.desktop" ];
      had-bluetooth-devices-setup = true;
      last-selected-power-profile = "performance";
      welcome-dialog-last-shown-version = "43.0";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      background-opacity = 0.8;
      dash-max-icon-size = 48;
      dock-fixed = false;
      dock-position = "LEFT";
      height-fraction = 0.9;
      isolate-workspaces = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
    };

    "org/gnome/shell/extensions/ding" = {
      check-x11wayland = true;
      show-home = false;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      dash-icon-size = 64;
      events-button = true;
      keyboard-layout = true;
      max-displayed-search-results = 0;
      panel = true;
      panel-in-overview = true;
      ripple-box = false;
      search = false;
      show-apps-button = false;
      startup-status = 0;
      theme = true;
      weather = true;
      window-demands-attention-focus = true;
      window-maximized-on-create = false;
      window-picker-icon = true;
      workspace = true;
      workspace-peek = true;
      workspace-switcher-should-show = true;
      workspace-wrap-around = true;
      workspaces-in-app-grid = false;
      world-clock = true;
    };

    "org/gtk/settings/color-chooser" = {
      custom-colors = [ (mkTuple [ 0.23529411764705882 0.7058823529411765 0.29411764705882354 1.0 ]) ];
      selected-color = mkTuple [ true 0.0 0.0 0.0 1.0 ];
    };
  };
}
