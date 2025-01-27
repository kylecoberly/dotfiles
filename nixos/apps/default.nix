{ config, lib, pkgs, ... }:

{
  imports = [
    ./unix.nix
  ];

  home.packages = with pkgs; [
      chromium
      obsidian
      rambox
      neovim
      obs-studio
      docker
      gparted
      neovim
      # etcher?
      # gimp?
      # vs-code?
      # discord?
      # slack?
      # handbrake?
      # firefox?
      # google-chrome?
      # miro?
      # simple scan?
      # teams?
      # todoist?
      # zoom?

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
