{ config, lib, pkgs, ... }:

{
  services.spice-webdavd.enable = true; # Allows VM to share folders
  services.spice-vdagentd.enable = true; # Make displays scale when running in a VM
  services.spice-autorandr.enable = true;
  services.qemuGuest.enable = true; # For QEMU VMs
}
