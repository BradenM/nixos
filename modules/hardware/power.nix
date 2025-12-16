{ config, lib, pkgs, ... }:
{
  # Intel thermald for better CPU thermal/power management
  services.thermald.enable = true;

  # powertop auto-tune for peripheral power savings
  # (USB autosuspend, audio codec, SATA link power, etc.)
  powerManagement.powertop.enable = true;

  # kernel parameters for laptop power saving
  boot.kernelParams = [
    "nmi_watchdog=0"
  ];

  # laptop mode (aggressive writeback when on battery)
  powerManagement.enable = true;

  # udev rules for power saving on peripherals
  services.udev.extraRules = ''
    # enable power saving for Intel audio codec
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{class}=="0x040300", ATTR{power/control}="auto"
  '';
}
