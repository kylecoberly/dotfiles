{ config, lib, pkgs, ... }:

{
  ## Desktop
  services.displayManager.autoLogin = {
    enable = true;
    user = "kylecoberly";
  };

  services.flatpak.enable = true;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.just-perfection
    flameshot
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
