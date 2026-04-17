{ config, lib, pkgs, ... }:

{
  programs.alacritty.enable = true;
  xdg = {
    configFile."alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/alacritty/alacritty.toml";
    configFile."alacritty/melange.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/alacritty/melange.toml";
  };
}
