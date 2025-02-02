{ config, lib, pkgs, ... }:

{
  imports = [
    ./dcon
    ./git
    ./alacritty
    ./tmux
    ./zsh
  ];
}
