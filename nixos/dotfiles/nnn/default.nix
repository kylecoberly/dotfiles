{ config, lib, pkgs, ... }:

{
  programs.nnn = {
    enable = true;
    bookmarks = {
      "P" = "${config.home.homeDirectory}/Projects";
      "d" = "${config.home.homeDirectory}/dotfiles";
    };
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      mediainfo
      sxiv
    ];
  };
}
