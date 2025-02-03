{ config, lib, pkgs, ... }:

{
  xdg = {
    # configFile."obsidian/obsidian.json".source = "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/obsidian/obsidian.json";
  };
}
