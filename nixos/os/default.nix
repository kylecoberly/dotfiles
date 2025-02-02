{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./locale.nix
    ./users.nix
    ./packages.nix
    ./input.nix
    ./fonts.nix
    ./peripherals.nix
    ./networking.nix
    ./media.nix
  ];
}
