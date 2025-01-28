{ config, lib, pkgs, ... }:

{
  xdg = {
    enable = true;
    configFile."git/config".source = "../../apps/.gitconfig";
  }
}
