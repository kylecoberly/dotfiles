{ config, pkgs, ... }: {
  imports = [
    ./apps
    ./dconf.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "kylecoberly";
    homeDirectory = "/home/kylecoberly";
    stateVersion = "24.11";
  };
}
