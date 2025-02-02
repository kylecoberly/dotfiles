{ config, lib, pkgs, ... }:

{
  imports = [
    ./dconf.nix
    ./git
    ./alacritty
    ./tmux
    ./zsh.nix
  ];
}
