{ config, lib, pkgs, ... }:

{
  options.programs.git.enable = true;
  options.xdg.configFile = {
    "git/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/git/.gitconfig";
  };
  options.home.file = {
    ".gitignore" = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/git/.gitignore";
  };
}
