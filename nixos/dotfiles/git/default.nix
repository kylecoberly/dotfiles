{ config, lib, pkgs, ... }:

{
  programs.git.enable = true;
  xdg.configFile = {
    "git/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/git/.gitconfig";
  };
  home.file = {
    ".gitignore".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/git/.gitignore";
  };
}
