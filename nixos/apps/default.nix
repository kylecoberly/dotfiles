{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; {
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
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };
    git = {
      enable = true;
    };
    # Some programs need SUID wrappers, can be configured further or are started in user sessions.
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
