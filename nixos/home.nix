{ inputs, nixpkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  programs.home-manager.enable = true
  home.username = "kylecoberly"
  home.homeDirectory = "/home/kylecoberly"
  home.stateVersion = "24.11"

  ## User
  home.packages = with pkgs; {
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
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };
    git = {
      enable = true;
    };
    # Some programs need SUID wrappers, can be configured further or are started in user sessions.
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
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
