{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    dnsutils
    nmap
    iftop
  ];
}
