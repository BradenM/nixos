{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./disko.nix
    ./hardware.nix
    ./persistence.nix

    ../../modules/core
    ../../modules/hardware
    ../../modules/desktop
    ../../modules/services
  ];

  networking.hostName = "braden-serval-ws";
  # for dynamically linked bins
  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";
}
