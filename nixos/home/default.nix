{ config, pkgs, ... }: {
  users.users.kylecoberly.isNormalUser = true;

  # Allow HM to manage itself
  programs.home-manager.enable = true;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kylecoberly = { config, pkgs, ... }: {
      # Home manager modules, not NixOS modules
      imports = [
        ./apps.nix
        ../dotfiles
      ];

      home = {
        username = "kylecoberly";
        homeDirectory = "/home/kylecoberly";
        stateVersion = "24.11";
      };
      xdg = { # Use standard folders
        enable = true;
      };
    };
  };
}
