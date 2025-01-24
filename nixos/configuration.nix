{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    # Flakes clones its dependencies through the git command, so git must be installed first
    git
    vim
    wget
  ];

  # Set the default editor to vim
  environment.variables.EDITOR = "nvim";
}
