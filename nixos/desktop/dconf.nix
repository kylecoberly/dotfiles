{ config, lib, pkgs, ... }:

{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "just-perfection"
        ];
        favorite-apps = [
          "chromium.desktop"
        ];
      };
      # just-perfection/workspace wraparound
      # just-perfection/workspace peek
      # just-perfection/popup delay
      # just-perfection/dash icon size 64px

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 3;
        workspace-names = [
          "Home"
          "Web"
          "Work"
        ];
        visual-bell = true;
        visual-bell-type = "frame-flash";
      };
      "/org/gnome/shell/extensions/just-perfection/workspace-switcher-should-show" = true;
      "/org/gnome/shell/extensions/just-perfection/workspace-peek" = true;
      "/org/gnome/shell/extensions/just-perfection/workspaces-in-app-grid" = true;
    };
  };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "gruvbox";
  #     package = pkgs.palenight-theme;
  #   };
  # }
}
