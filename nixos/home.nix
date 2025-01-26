{ config, pkgs, ... }: {
  home = {
    username = "kylecoberly";
    homeDirectory = "/home/kylecoberly";
    stateVersion = "24.11";
    packages = with pkgs; [
        chromium
        obsidian
        rambox
        neovim
        obs-studio
        docker
        # Languages
        # asdf-vm
        # perl
        # ruby
        # python3
        # php
        # go
        # rustc
        # deno
        # luarocks
        # html-tidy
    ];
  };

  programs = {
    home-manager.enable = true;
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };
    git = {
      enable = true;
    };
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
