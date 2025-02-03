{ config, lib, pkgs, ... }:

{
  xdg = {
    configFile."obsidian/obsidian.json".source = "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/obsidian/obsidian.json";
    configFile."obsidian/Preferences".source = "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/obsidian/Preferences";
  };
}
