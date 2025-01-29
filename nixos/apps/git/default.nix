{ config, lib, pkgs, ... }:

{
  programs.git.enable = true;
  xdg.configFile = {
    "git/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/git/.gitconfig";
  };
  home.file = {
    ".gitignore".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/git/.gitignore";
  };
}
