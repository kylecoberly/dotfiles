{ config, lib, pkgs, ... }:

{
  xdg = {
    enable = true;
    configFile = {
      "git/config" = {
        source = config.mkOutOfStoreSymLink "${config.home.homeDirectory}/dotfiles/nixos/apps/dotfiles/.gitconfig";
      };
    };
  };
}
