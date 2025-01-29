{ config, lib, pkgs, ... }:

{
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

  config.environment.pathsToLink = [ "/share/zsh" ];
}
