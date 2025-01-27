{ config, lib, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./media.nix
    ./networking.nix
    ./input.nix
    ./boot.nix
  ];
}
