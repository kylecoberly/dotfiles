# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + ./wallpaper.jpeg;
    };
  };
}
