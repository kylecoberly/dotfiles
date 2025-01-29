{ lib, pkgs, osConfig, ... }:

{
  osConfig.programs.git.enable = true;
  osConfig.xdg.configFile = {
    "git/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/git/.gitconfig";
  };
  osConfig.home.file = {
    ".gitignore".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/apps/git/.gitignore";
  };
}
