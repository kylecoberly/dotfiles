{ config, lib, pkgs, ... }:

{
  imports = [
    ./1password
    ./alacritty
    ./dconf
    ./display
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
  ];
}
