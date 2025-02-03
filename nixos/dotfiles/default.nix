{ config, lib, pkgs, ... }:

{
  imports = [
    ./dconf
    ./git
    ./alacritty
    ./tmux
    ./zsh
    ./higan
    ./dolphin-emu
    ./autostart.nix
  ];
}
