{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./locale.nix
    ./users.nix
    ./gnome.nix
    ./apps.nix
    ./input.nix
    ./fonts.nix
    ./peripherals.nix
    ./networking.nix
    ./media.nix
  ];
}
