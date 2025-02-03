{ config, lib, pkgs, ... }:

{
  xdg = {
    configFile."autorandr/docked-single/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/display/docked-single/config";
    configFile."autorandr/docked-single/setup".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/display/docked-single/setup";

    configFile."autorandr/undocked/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/display/undocked/config";
    configFile."autorandr/undocked/setup".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/display/undocked/setup";
  };
}
