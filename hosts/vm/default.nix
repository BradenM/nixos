{ config, lib, pkgs, inputs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ./persistence.nix

    ../../modules/core
    ../../modules/desktop
    ../../modules/services
  ];

  networking.hostName = "nixos-vm";

  # VM-specific boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.systemd.enable = true;
  };

  # override user config for VM (simple password instead of file)
  users.users.braden = {
    isNormalUser = true;
    description = "Braden Mars";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "test";
    shell = pkgs.zsh;
  };

  # VirtIO graphics
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # disable NVIDIA-specific environment variables
  environment.sessionVariables = lib.mkForce {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  # VM doesn't need System76 power management
  hardware.system76.enableAll = lib.mkForce false;
  services.power-profiles-daemon.enable = lib.mkForce false;

  # use software rendering for Sway in VM
  environment.systemPackages = with pkgs; [
    mesa
  ];

  system.stateVersion = "25.11";
}
