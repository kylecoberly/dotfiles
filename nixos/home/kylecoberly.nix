{ inputs, lib, config, pkgs, ... }: {
  ## User
  home-manager.users.kylecoberly = {
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
    git = {
      enable = true;
    };
  };
}
