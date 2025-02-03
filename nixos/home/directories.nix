{ config, lib, pkgs, ... }:

{
  home.file."dotfiles" = {
    source = builtins.fetchGit {
      url = "https://github.com/kylecoberly/dotfiles.git";
      ref = "refs/heads/master";
    };
    recursive = true;
  };
  xdg.userDirs.templates = null;
  xdg.userDirs.music = null;
  xdg.userDirs.pictures = null;
  xdg.userDirs.videos = null;
  xdg.userDirs.publicShare = null;
  xdg.userDirs.extraConfig = [
    "Projects"
    "Temp"
  ];
}
