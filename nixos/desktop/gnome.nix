{ config, lib, pkgs, ... }:

{
  ## Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kylecoberly";

  environment.systemPackages = with pkgs; [
    git
    gnome-tweaks
    gnomeExtensions.just-perfection
    flameshot
    openssh
    autorandr
  ];

  ## Remove from Gnome
  environment.gnome.excludePackages = with pkgs; [
    baobab      # disk usage analyzer
    cheese      # photo booth
    epiphany    # web browser
    gedit       # text editor
    totem       # video player
    geary       # email client
    seahorse    # password manager
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-screenshot
    gnome-weather
    gnome-connections
    ## Keep these:
    # gnome-system-monitor
    # eog         # image viewer
    # simple-scan # document scanner
    # yelp        # help viewer
    # evince      # document viewer
    # file-roller # archive manager
    # gnome-calculator
    # gnome-font-viewer
    # gnome-disk-utility
  ];
}
