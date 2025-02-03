# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.enable = true;
  imports = [
    ./wacom-tablet.nix
    ./keyboard.nix
    ./mouse.nix
    ./file-picker.nix
    ./calculator.nix
    ./interface.nix
    ./boxes.nix
    ./sound.nix
    ./simple-scan.nix
    ./calendar.nix
    ./system.nix
    ./interface.nix
    ./power.nix
  ];
}
