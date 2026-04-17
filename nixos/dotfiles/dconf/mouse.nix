# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = 0.517786561264822;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.38773946360153255;
      two-finger-scrolling-enabled = true;
    };
  };
}

