{ config, lib, pkgs, ... }:

{
  xdg.configFile = {
    "dolphin-emu" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/dolphin";
      recursive = true;
    };
  };
}
