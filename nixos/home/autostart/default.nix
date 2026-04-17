{ config, lib, pkgs, ... }:

{
  xdg = {
    configFile."autostart/Alacritty.desktop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/home/autostart/Alacritty.desktop";
    configFile."autostart/google-chrome.desktop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/home/autostart/google-chrome.desktop";
    configFile."autostart/obsidian.desktop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/home/autostart/obsidian.desktop";
    configFile."autostart/rambox_rambox.desktop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/home/autostart/rambox_rambox.desktop";
  };
}
