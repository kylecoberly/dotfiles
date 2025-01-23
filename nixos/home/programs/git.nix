{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;
    includes = [{
      path = "~/dotfiles/apps/.gitconfig";
    }];
  };
}
