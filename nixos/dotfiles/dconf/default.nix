# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.enable = true;
  imports = [
    ./system.nix
    ./power.nix
    ./sound.nix
    
    ./keyboard.nix
    ./mouse.nix
    ./wacom-tablet.nix
    
    ./interface.nix
    ./wallpaper.nix
    ./file-picker.nix
    
    ./calendar.nix
    ./calculator.nix
    ./boxes.nix
    ./simple-scan.nix
  ];
}
