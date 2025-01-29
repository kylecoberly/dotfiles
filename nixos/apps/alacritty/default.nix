{ lib, pkgs, osConfig, ... }:

{
  osConfig.programs.alacritty.enable = true;
  osConfig.xdg = {
    configFile."alacritty/alacritty.toml".source = "../../apps/alacritty/alacritty.toml";
    configFile."alacritty/melange.toml".source = "../../apps/alacritty/melange.toml";
  };
}
