{ config, pkgs, ... }:
{
  xdg = {
    configFile."obs-studio" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nixos/dotfiles/obs-studio";
      recursive = true;
    }
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
      input-overlay
      obs-vintage-filter
      obs-backgroundremoval
      obs-rgb-levels-filter
      obs-pipewire-audio-capture
    ];
  };
}
