{ config, lib, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./dconf.nix
  ];
}
