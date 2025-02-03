{ config, lib, pkgs, ... }:

{
  programs.nnn = {
    enable = true;
    bookmarks = {
      "P" = "~/Projects";
      "d" = "~/dotfiles";
    };
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      mediainfo
      sxiv
    ];
  };
}
