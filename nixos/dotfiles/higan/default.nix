{ config, lib, pkgs, ... }:

{
  xdg.configFile = {
    "higan/settings.bml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/higan/settings.bml";
  };
}
