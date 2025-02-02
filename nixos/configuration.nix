{ config, pkgs, ... }:

{
  imports = [
    ./nix
    ./systems/xps13
    ./os
    ./desktops/gnome
    ./home.nix
  ];

  system.stateVersion = "24.11";
}
