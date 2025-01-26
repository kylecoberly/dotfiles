{ config, pkgs, ... }: {
  imports = [
    ./apps
  ];

  home = {
    username = "kylecoberly";
    homeDirectory = "/home/kylecoberly";
    stateVersion = "24.11";
  };

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
