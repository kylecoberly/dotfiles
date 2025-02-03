{ config, lib, pkgs, ... }:

{
  xdg.autoStart = {
    packages = with pkgs; [
      obsidian
      rambox
      google-chrome
      alacritty
    ];
  };
}
