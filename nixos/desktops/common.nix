{ inputs, lib, config, pkgs, ... }: {
  ## Desktop
  services.xserver.enable = true;

  ### Keyboard & Mouse
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:swapcaps";
  };
  console.useXkbConfig = true;
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
    };
    touchpad = {
      naturalScrolling = true;
    };
  };

  ## Services
  services.openssh.enable = true;
  services.spice-webdavd.enable = true; # Allows VM to share folders
  services.spice-vdagentd.enable = true; # Make displays scale when running in a VM
  services.spice-autorandr.enable = true;
  services.qemuGuest.enable = true; # For QEMU VMs
  services.flatpak.enable = true;
  networking.firewall.enable = false;

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    zsh
    neovim
    tmux
    alacritty
    flameshot
    vlc
    playerctl
    git
    ranger
    bat
    htop-vim
    mawk
    ncdu
    tree
    curl
    wget
    ffmpeg
    rar
    p7zip
    openssh
    xclip
    unrar
    ripgrep
    fd
    jq
    autorandr
    gnused
    entr
    tldr
  ];
}
