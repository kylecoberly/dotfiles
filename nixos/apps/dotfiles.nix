{ config, lib, pkgs, ... }:

{
  imports = [
    ./git
    ./alacritty
    ./tmux
    ./zsh.nix
  ];
  xdg = {
    enable = true;
  };
}
