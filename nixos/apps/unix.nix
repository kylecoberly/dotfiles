{ config, lib, pkgs, ... }:

{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  home.packages = with pkgs; [
    zsh

    # Navigation
    ranger
    tree
    bat

    # Compression
    rar
    unrar
    zip
    unzip
    p7zip
    xz

    # Networking
    dnsutils
    nmap
    iftop

    # Fetching
    curl
    wget

    # Desktop interaction
    xclip

    # Monitoring
    btop
    htop-vim

    # Manipulation
    mawk
    jq

    ## Search
    ripgrep
    tldr
    fd
  ];
}
