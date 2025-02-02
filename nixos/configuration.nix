{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./os
    ./home
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "24.11";
}
