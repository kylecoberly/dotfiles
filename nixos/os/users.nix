{ config, lib, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.users.kylecoberly = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}
