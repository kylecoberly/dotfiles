{
  description = "Kyle Coberly's NixOS configuration";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ...}@inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      xps13 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nix.nix
          ./hosts/xps13.nix
        ];
      };
    };
  };
}
