{ config, lib, pkgs, ... }:

{
  osConfig.home.packages = with pkgs; [
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

  osConfig.environment.variables.VISUAL = "nvim";
  osConfig.environment.variables.EDITOR = "nvim";
}
