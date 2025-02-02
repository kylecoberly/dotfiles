{ config, lib, pkgs, ... }:

{
  imports = [
    # dconf.nix needs to be imported by home manager
    ./fonts.nix
    ./gnome.nix
  ];
}
