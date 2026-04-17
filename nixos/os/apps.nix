{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    zsh

    # Navigation
    ranger
    tree
    bat

    # Compression
    unrar
    zip
    unzip
    p7zip
    xz

    # Networking
    dnsutils
    nmap
    iftop
    openssh

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

    ## System
    parted
  ];
}
