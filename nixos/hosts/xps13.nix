{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./common.nix
    ../desktops/gnome.nix
  ];

  home-manager = {
    backupFileExtension = "back";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.kylecoberly = import ../home/kylecoberly.nix;
  };

  networking.hostName = "nixos-xps13";

  environment.systemPackages = with pkgs; [
  ];
}
