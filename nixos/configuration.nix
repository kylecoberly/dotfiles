{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  users.users = {
   kylecoberly = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      ## initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["networkmanager docker wheel"];
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  inputs.nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Flakes clones its dependencies through the git command, so git must be installed first
    gnome-tweaks
    # gnome-shell-extension-just-perfection
    git
    nvim
    wget
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
  ## Remove from Gnome
  environment.gnome.excludePackages = with pkgs; [
    baobab      # disk usage analyzer
    cheese      # photo booth
    epiphany    # web browser
    gedit       # text editor
    totem       # video player
    geary       # email client
    seahorse    # password manager
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-screenshot
    gnome-weather
    gnome-connections
    ## Keep these:
    # gnome-system-monitor
    # eog         # image viewer
    # simple-scan # document scanner
    # yelp        # help viewer
    # evince      # document viewer
    # file-roller # archive manager
    # gnome-calculator
    # gnome-font-viewer
    # gnome-disk-utility
  ];

  # Set the default editor to vim
  environment.variables.EDITOR = "nvim";

  ## Desktop
  services.xserver.enable = true;

  ### Keyboard & Mouse
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:swapcaps";
  };
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
    };
    touchpad = {
      naturalScrolling = true;
    };
  };

  ## Bootloader
  boot = {
    loader = {
      grub.enable = true;
      grub.device = "/dev/vda";
      grub.useOSProber = true;
    };
    kernel.sysctl = { "vm.swappiness" = 10;};
  };
  powerManagement.cpuFreqGovernor = "performance"

  ## Networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  ## Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ## Peripherals
  services.printing.enable = true;

  ## Locale
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  home-manager = {
    backupFileExtension = "back";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  ## Gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kylecoberly";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  ## Services
  services.openssh.enable = true;
  services.spice-webdavd.enable = true; # Allows VM to share folders
  services.spice-vdagentd.enable = true; # Make displays scale when running in a VM
  services.spice-autorandr.enable = true;
  services.qemuGuest.enable = true; # For QEMU VMs
  services.flatpak.enable = true;
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
