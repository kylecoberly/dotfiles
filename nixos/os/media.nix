{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vlc
    playerctl
    ffmpeg
  ];

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
