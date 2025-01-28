{ config, lib, pkgs, ... }:

{
  imports = [
    ./unix.nix
    ./dotfiles.nix
  ];

  home.packages = with pkgs; [
    # Browsers
    google-chrome
    firefox

    # Productivity
    obsidian
    rambox
    libreoffice
    zoom-us
    tmux
    # miro?
    # todoist # In Rambox

    # Production
    obs-studio
    gimp-with-plugins

    # Development
    docker
    neovim
    vs-code-with-extensions
    asdf-vm

    # Communication - These are in Rambox
    # discord
    # slack
    # teams

    # Tools
    ventoy # Thumb drive burner
    handbrake # Vide and DVD ripper
    gparted # Partition manager
    simple-scan # Document scanner

    # Remotes and VMs
    gnome-boxes
    remmina
  ];

  programs = {
    home-manager.enable = true;
  };
}
