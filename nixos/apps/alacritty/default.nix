{ config, lib, pkgs, ... }:

{
  config.programs.alacritty.enable = true;
  config.xdg = {
    configFile."alacritty/alacritty.toml".source = "../../apps/alacritty/alacritty.toml";
    configFile."alacritty/melange.toml".source = "../../apps/alacritty/melange.toml";
  };
}
