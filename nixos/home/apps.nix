{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    google-chrome
    firefox

    # Productivity
    _1password-cli
    _1password-gui
    obsidian
    rambox
    libreoffice
    zoom-us
    tmux
    # miro?
    # todoist # In Rambox

    # Production
    # obs-studio
    gimp-with-plugins

    # Development
    docker
    neovim
    vscode
    asdf-vm
    awscli2
    flyctl

    # Communication - These are in Rambox
    # discord
    # slack
    # teams

    # Games
    higan
    dolphin-emu
    steam

    # Tools
    ventoy # Thumb drive burner
    handbrake # Video and DVD ripper
    simple-scan # Document scanner
    gparted # Partition manager
    just # Shell command runner
    nnn # File explorer

    # Remotes and VMs
    gnome-boxes
    remmina
  ];
}
