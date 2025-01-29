{ config, lib, pkgs, ... }:

{
  config.programs.git.enable = true;
  config.xdg.configFile = {
    "git/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/git/.gitconfig";
  };
  config.home.file = {
    ".gitignore".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/git/.gitignore";
  };
}
