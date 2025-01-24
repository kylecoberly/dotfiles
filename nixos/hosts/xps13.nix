{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./common.nix
    ../hardware-configuration.nix
    ../desktops/gnome.nix
    ../home/kylecoberly.nix
  ];

  inputs.home-manager = {
    backupFileExtension = "back";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  networking.hostName = "nixos-xps13";

  environment.systemPackages = with pkgs; [
  ];
}
