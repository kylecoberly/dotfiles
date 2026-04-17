# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/simple-scan" = {
      jpeg-quality = 84;
      page-side = "front";
      photo-dpi = 1200;
      save-directory = "file:///home/kylecoberly/Pictures/Scans/";
      save-format = "image/png";
      text-dpi = 600;
    };
  };
}
