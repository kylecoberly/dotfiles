{ config, lib, pkgs, ... }:

let
  # Mac: onePassPath = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  onePassPath = "~/.1password/agent.sock";
in {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    forwardAgent = true;
    extraConfig = ''
      Host *
          IdentityAgent

      Host serena
          HostName 192.168.1.200
          User kylecoberly

      Host home
          HostName coberly.ddns.net
          User kylecoberly

      Host github.com
          IdentitiesOnly yes ${onePassPath}
      '';
  };
}
