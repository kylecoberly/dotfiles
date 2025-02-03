# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/peripherals/stylus/8b808d34" = {
      eraser-pressure-curve = [ 0 0 100 100 ];
      pressure-curve = [ 25 0 100 75 ];
      secondary-button-action = "default";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357" = {
      keep-aspect = true;
      mapping = "absolute";
      output = [ "HWP" "HP 27es" "3CM6310RWK   " ];
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonA" = {
      action = "keybinding";
      keybinding = "v";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonB" = {
      action = "keybinding";
      keybinding = "<Control>z";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonC" = {
      action = "keybinding";
      keybinding = "<Shift><Control>z";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonD" = {
      action = "keybinding";
      keybinding = "p";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonE" = {
      action = "keybinding";
      keybinding = "<Control>0";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonF" = {
      action = "keybinding";
      keybinding = "<Control>minus";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonG" = {
      action = "keybinding";
      keybinding = "<Control>equal";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonH" = {
      action = "keybinding";
      keybinding = "space";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/ringA-ccw-mode-0" = {
      action = "keybinding";
      keybinding = "<Control>minus";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/ringA-cw-mode-0" = {
      action = "keybinding";
      keybinding = "<Control>equal";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360" = {
      keep-aspect = true;
      output = [ "AUS" "ASUS MB16AMT" "K8LMTF083442" ];
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonA" = {
      action = "keybinding";
      keybinding = "v";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonB" = {
      action = "keybinding";
      keybinding = "<Primary>z";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonC" = {
      action = "keybinding";
      keybinding = "<Primary>y";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonD" = {
      action = "keybinding";
      keybinding = "p";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonE" = {
      action = "keybinding";
      keybinding = "<Primary>0";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonF" = {
      action = "keybinding";
      keybinding = "<Primary>minus";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonG" = {
      action = "keybinding";
      keybinding = "<Primary>equal";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonH" = {
      action = "keybinding";
      keybinding = "space";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/ringA-ccw-mode-0" = {
      action = "keybinding";
      keybinding = "<Primary>minus";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/ringA-cw-mode-0" = {
      action = "keybinding";
      keybinding = "<Primary>equal";
    };
  };
}
