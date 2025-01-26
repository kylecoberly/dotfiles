{ config, lib, pkgs, ... }:

{
  imports = [
    ./networking.nix
  ];
  home.packages = with pkgs; [
      chromium
      obsidian
      rambox
      neovim
      obs-studio
      docker
      # Languages
      # asdf-vm
      # perl
      # ruby
      # python3
      # php
      # go
      # rustc
      # deno
      # luarocks
      # html-tidy
  ];

  programs = {
    home-manager.enable = true;
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };
    git = {
      enable = true;
    };
  };
}
