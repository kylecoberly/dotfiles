# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = false;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
  };
}
