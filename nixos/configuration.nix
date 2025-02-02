{ inputs, config, pkgs, ... }:

{
  imports = [
    ./systems/xps13
    ./os
  ];
  environment.etc = {
    # somerc.source = /etc/somerc;
    "tmux/tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/tmux/tmux.conf";
      recursive = true;
    };
    "tmux/tmux.conf.local" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/tmux/tmux.conf.local";
      recursive = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
