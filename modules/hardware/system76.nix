{ config, lib, pkgs, ... }:

{
  hardware.system76 = {
    enableAll = true;
  };

  # disable conflicting power management
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;

  environment.systemPackages = with pkgs; [
    firmware-manager
  ];
}
