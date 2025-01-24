{ inputs, lib, config, pkgs, ... }: {
  programs.home-manager.enable = true
  home.username = "kylecoberly"
  home.homeDirectory = "/home/kylecoberly"
  home.stateVersion = "24.11"

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../hardware-configuration.nix
    ../desktops/gnome.nix
  ];

  ## Bootloader
  boot = {
    loader = {
      grub.enable = true;
      grub.device = "/dev/vda";
      grub.useOSProber = true;
    };
    kernel.sysctl = { "vm.swappiness" = 10;};
  };

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

  ## User
  home.packages = with pkgs; {
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
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };
    git = {
      enable = true;
    };
  };
}
