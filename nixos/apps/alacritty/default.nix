{ config, lib, pkgs, ... }:

{
  config.programs.alacritty = enable;
  config.xdg = {
    configFile."alacritty/alacritty.toml".source = "../../apps/alacritty/alacritty.toml";
    configFile."alacritty/melange.toml".source = "../../apps/alacritty/melange.toml";
  };
}
