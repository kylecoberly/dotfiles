{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./os/boot.nix
    ./os/users.nix
    ./os/gnome.nix
    ./os/input.nix
    ./os/peripherals.nix
    ./os/locale.nix
    ./os/networking.nix
    ./os/media.nix
    ./os/vm.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "24.11";
}
