{ config, lib, pkgs, ... }:

{
  home.file."Projects" = {
    target = "Projects";
    recursive = true;
  };
  home.file."Temp" = {
    target = "Temp";
    recursive = true;
  };
}
