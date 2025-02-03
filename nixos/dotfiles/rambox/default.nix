{ config, lib, pkgs, ... }:

{
  xdg = {
    configFile."rambox/Settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/rambox/Settings.json";
  };
}
