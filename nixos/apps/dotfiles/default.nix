{ config, lib, pkgs, ... }:

{
  xdg = {
    enable = true;
    configFile = {
      "git/config" = {
        source = config.lib.file.mkOutOfStoreSymLink "${config.home.homeDirectory}/dotfiles/nixos/apps/dotfiles/.gitconfig";
      };
    };
  };
}
