{ config, lib, pkgs, ... }:

{
  boot = {
    loader = {
      grub.enable = true;
      grub.device = "/dev/vda";
      grub.useOSProber = true;
    };
    kernel.sysctl = { "vm.swappiness" = 10;};
  };
}
