{
  # Home manager modules, not NixOS modules
  imports = [
    ./directories.nix
    ./apps.nix
    ../dotfiles
    ./autostart.nix
  ];

  # Allow HM to manage itself
  programs.home-manager.enable = true;

  home = {
    username = "kylecoberly";
    homeDirectory = "/home/kylecoberly";
    stateVersion = "24.11";
  };
  xdg = { # Use standard folders
    enable = true;
  };
}
