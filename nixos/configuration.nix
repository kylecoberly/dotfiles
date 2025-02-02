{ inputs, config, pkgs, ... }:

{
  imports = [
    ./systems/xps13
    ./os
  ];
  environment.etc = {
    "tmux" = {
      source = "~/dotfiles/nixos/dotfiles/tmux";
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
