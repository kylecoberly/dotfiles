{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
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

  config.environment.variables.VISUAL = "nvim";
  config.environment.variables.EDITOR = "nvim";
}
