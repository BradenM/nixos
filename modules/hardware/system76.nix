{ config, lib, pkgs, ... }:

{
  hardware.system76 = {
    enableAll = true;
  };

  # disable conflicting power management
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;
  
  # firmware updates
  services.fwupd.enable = true;

  # thunderbold daemon
  services.hardware.bolt.enable = true;

  environment.systemPackages = with pkgs; [
    firmware-manager
  ];
}
