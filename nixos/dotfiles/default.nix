{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./dconf
    ./autorandr
    ./dolphin-emu
    ./git
    ./higan
    ./nnn
    ./nvim
    ./obs-studio
    ./obsidian
    ./rambox
    ./ssh
    ./tmux
    ./zsh
    ./nextcloud
  ];
}
