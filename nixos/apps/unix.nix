{ config, lib, pkgs, ... }:

{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  home.packages = with pkgs; [
    zsh
    ranger
    tree
    bat

    rar
    unrar
    zip
    unzip
    p7zip
    xz

    curl
    wget

    btop
    htop-vim
    mawk
    ripgrep
    fd
    jq
    entr
    tldr
  ];
}
