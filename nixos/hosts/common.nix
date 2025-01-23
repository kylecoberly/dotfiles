{ inputs, lib, config, pkgs, ... }: {
  ## Bootloader
  boot = {
    loader = {
      grub.enable = true;
      grub.device = "/dev/vda";
      grub.useOSProber = true;
    }
    kernel.sysctl = { "vm.swappiness" = 10;};
  }

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
}
