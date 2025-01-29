{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      nerd-fonts
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = [  "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "NotoMono Nerd Font" ];
      };
    };
  };
}
