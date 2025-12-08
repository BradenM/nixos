{ config, lib, pkgs, ... }:

{
  users.mutableUsers = false;

  users.users.braden = {
    isNormalUser = true;
    description = "Braden Mars";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    hashedPasswordFile = "/persist/passwords/braden";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = true;
}
