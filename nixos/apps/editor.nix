{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
      neovim
      # luarocks
      # html-tidy
  ];
}

