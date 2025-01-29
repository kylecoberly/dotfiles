{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix.nix
    ./boot.nix
    ./locale.nix
    ./users.nix
    ./input.nix
    ./peripherals.nix
    ./networking.nix
    ./media.nix
    ./vm.nix
    ../desktop
  ];
}
