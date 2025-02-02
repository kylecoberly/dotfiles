{
  # Home manager modules, not NixOS modules
  imports = [
    ./apps.nix
    ../dotfiles
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
