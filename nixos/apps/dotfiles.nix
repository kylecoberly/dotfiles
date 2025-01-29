{ config, lib, pkgs, ... }:

{
  imports = [
    ./git
    ./alacritty
    ./zsh.nix
  ];
  xdg = {
    enable = true;
  };
}
