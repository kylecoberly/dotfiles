{ config, lib, pkgs, ... }:

{
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
      options = "ctrl:swapcaps";
    };
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
      touchpad = {
        naturalScrolling = true;
      };
    };
  };
}
