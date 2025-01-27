{ config, pkgs, ... }: {
  imports = [
    ./apps
  ];

  programs.home-manager.enable = true;

  home = {
    username = "kylecoberly";
    homeDirectory = "/home/kylecoberly";
    stateVersion = "24.11";
  };
}
