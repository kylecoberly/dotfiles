{ config, lib, pkgs, ... }:

{
  imports = [
    ./unix.nix
  ];

  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;

  home.packages = with pkgs; [
      chromium
      obsidian
      rambox
      neovim
      obs-studio
      docker
      gparted
      neovim
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
