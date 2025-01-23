{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  ## Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  ## Networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

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

  ### Gnome + GDM
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "gruvbox";
  #     package = pkgs.palenight-theme;
  #   };
  # }
	#  dconf.settings = {
	#    "org/gnome/shell" = {
	#      disable-user-extensions = false;
	#      enabled-extensions = [
	#        ""
	#      ];
	#      favorite-apps = [
	#        "chromium.desktop"
	#      ];
	#    }
	#    "org/gnome/shell" = {
	#    }
	#    # just-perfection/workspace wraparound
	#    # just-perfection/workspace peek
	#    # just-perfection/popup delay
	#    # just-perfection/dash icon size 64px
	#    "org/gnome/desktop/wm/preferences" = {
	#      workspace-names = [
	#        "Home"
	# "Web"
	# "Work"
	#      ];
	#    }
  # };
  ### KDE Plasma 5 + SDDM
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;

  ## Peripherals
  services.printing.enable = true;

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

  ## User
  users.users.kylecoberly = {
    isNormalUser = true;
    description = "Kyle Coberly";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      chromium
      obsidian
      rambox
      neovim
      obs-studio
      docker
      # Languages
      # asdf-vm
      # perl
      # ruby
      # python3
      # php
      # go
      # rustc
      # deno
      # luarocks
      # html-tidy
    ];
  };
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kylecoberly";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  ## Programs
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    # gnome-shell-extension-just-perfection
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

  ## Remove from Gnome
  environment.gnome.excludePackages = with pkgs; [
    # baobab      # disk usage analyzer
    # cheese      # photo booth
    eog         # image viewer
    # epiphany    # web browser
    # gedit       # text editor
    simple-scan # document scanner
    # totem       # video player
    yelp        # help viewer
    evince      # document viewer
    file-roller # archive manager
    # geary       # email client
    # seahorse    # password manager
    gnome-calculator
    # gnome-calendar
    # gnome-characters
    # gnome-clocks
    # gnome-contacts
    gnome-font-viewer
    gnome-logs
    # gnome-maps
    # gnome-music
    # gnome-photos
    # gnome-screenshot
    gnome-system-monitor
    # gnome-weather
    gnome-disk-utility
    # pkgs.gnome-connections
  ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  ## Services
  services.openssh.enable = true;
  services.spice-webdavd.enable = true; # Allows VM to share folders
  services.spice-vdagentd.enable = true; # Make displays scale when running in a VM
  services.spice-autorandr.enable = true;
  services.qemuGuest.enable = true; # For QEMU VMs
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
