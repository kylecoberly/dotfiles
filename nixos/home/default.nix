{ config, pkgs, ... }: {
  programs.home-manager.enable = true;
  dconf.enable = true;

  home.stateVersion = "24.11";

  users.users.kylecoberly = isNormalUser = true;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kylecoberly = { config, pkgs, ... }: {
      imports = [
        ./apps.nix
        ../dotfiles
      ];

      programs.home-manager.enable = true;
      xdg = {
        enable = true;
      };

      home = {
        username = "kylecoberly";
        homeDirectory = "/home/kylecoberly";
      };
    }
  };
}
