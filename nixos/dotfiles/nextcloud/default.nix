{ config, lib, pkgs, ... }:

{
  programs.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
