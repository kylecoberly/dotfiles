{ config, lib, pkgs, ... }:

{
  imports = [
    ./dconf
    ./git
    ./alacritty
    ./tmux
    ./zsh
  ];
}
