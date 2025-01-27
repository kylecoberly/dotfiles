{ config, pkgs, ... }: {
  imports = [
    ./apps
    ./desktop/dconf.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "kylecoberly";
    homeDirectory = "/home/kylecoberly";
    stateVersion = "24.11";
  };
}
