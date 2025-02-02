{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./vm.nix
  ];
}
