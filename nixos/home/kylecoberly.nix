{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./programs/git.nix
  ];

  ## User
  users.users.kylecoberly = {
    isNormalUser = true;
    description = "Kyle Coberly";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
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
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = true;
    };
    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    jq.enable = true; # A lightweight and flexible command-line JSON processor
    ssh.enable = true;
  };
}
