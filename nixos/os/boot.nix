{ config, lib, pkgs, ... }:

{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/vda";
        useOSProber = true;
        configurationLimit = 10;
      };
    };
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };
}
