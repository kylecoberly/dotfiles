{ config, pkgs, ... }: {
  imports = [
    ./apps
    ./desktop/dconf.nix
  ];

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
  dconf.enable = true;

  home = {
    username = "kylecoberly";
    homeDirectory = "/home/kylecoberly";
    stateVersion = "24.11";
  };
}
