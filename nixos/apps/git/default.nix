{ config, lib, pkgs, ... }:

{
  programs.git = enable;
  xdg = {
    configFile."git/config".source = "../../apps/.gitconfig";
  }
}
