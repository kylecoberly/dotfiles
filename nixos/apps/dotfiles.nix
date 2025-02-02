{ config, lib, pkgs, ... }:

{
  imports = [
    ./git
    ./alacritty
    ./tmux
    ./zsh.nix
    ../desktop/dconf.nix
  ];
  xdg = {
    enable = true;
  };
}
