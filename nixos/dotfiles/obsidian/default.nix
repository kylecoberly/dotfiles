{ config, lib, pkgs, ... }:

{
  xdg.configFile = {
    "obsidian/obsidian.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/obsidian/obsidian.json";
  };
}
