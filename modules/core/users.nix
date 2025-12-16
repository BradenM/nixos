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
      "seat"
      "adbusers"
    ];
    hashedPasswordFile = "/persist/passwords/braden";
    shell = pkgs.zsh;
  };

  users.users.root.hashedPasswordFile = "/persist/passwords/root";

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = true;
}
