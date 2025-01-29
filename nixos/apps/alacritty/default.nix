{ config, lib, pkgs, ... }:

{
  options.programs.alacritty.enable = true;
  options.xdg = {
    configFile."alacritty/alacritty.toml".source = "../../apps/alacritty/alacritty.toml";
    configFile."alacritty/melange.toml".source = "../../apps/alacritty/melange.toml";
  };
}
