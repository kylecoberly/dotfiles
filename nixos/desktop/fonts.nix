{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      nerd-fonts.open-dyslexic
      nerd-fonts.roboto-mono
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-sans
      nerd-fonts.ubuntu-mono
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
