{ config, lib, pkgs, ... }:

{
  xdg.autostart = {
    enable = true;
    packages = with pkgs; [
      obsidian
      rambox
      google-chrome
      alacritty
    ];
  };
}
