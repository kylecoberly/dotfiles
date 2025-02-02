{ config, lib, pkgs, ... }:

{
  services = {
    spice-webdavd.enable = true; # Allows VM to share folders
    spice-vdagentd.enable = true; # Make displays scale when running in a VM
    spice-autorandr.enable = true;
    qemuGuest.enable = true; # For QEMU VMs
  };

  boot.kernel.sysctl.vm.swappiness = 10;
}
