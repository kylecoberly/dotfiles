{ config, pkgs, ... }: {
  imports = [
    ./apps
  ];

  programs.home-manager.enable = true;
  dconf.enable = true;

  home = {
    username = "kylecoberly";
    homeDirectory = "/home/kylecoberly";
    stateVersion = "24.11";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kylecoberly = import ./home.nix;
  };
}
