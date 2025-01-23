{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kylecoberly";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  ## Programs
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    # gnome-shell-extension-just-perfection
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

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "gruvbox";
  #     package = pkgs.palenight-theme;
  #   };
  # }
	#  dconf.settings = {
	#    "org/gnome/shell" = {
	#      disable-user-extensions = false;
	#      enabled-extensions = [
	#        ""
	#      ];
	#      favorite-apps = [
	#        "chromium.desktop"
	#      ];
	#    }
	#    "org/gnome/shell" = {
	#    }
	#    # just-perfection/workspace wraparound
	#    # just-perfection/workspace peek
	#    # just-perfection/popup delay
	#    # just-perfection/dash icon size 64px
	#    "org/gnome/desktop/wm/preferences" = {
	#      workspace-names = [
	#        "Home"
	# "Web"
	# "Work"
	#      ];
	#    }
  # };
}
