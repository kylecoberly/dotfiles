{ config, lib, pkgs, ... }:

{
  xdg = {
    configFile."nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/nvim";
      recursive = true;
    };
  };
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      typescript-language-server
      prettierd
      vscode-js-debug
      vscode-langservers-extracted
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
