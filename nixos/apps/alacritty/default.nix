{ config, lib, pkgs, ... }:

{
  programs.alacritty = enable;
  xdg = {
    configFile."alacritty/alacritty.toml".source = "../../apps/alacritty/alacritty.toml";
    configFile."alacritty/melange.toml".source = "../../apps/alacritty/melange.toml";
  }
}
