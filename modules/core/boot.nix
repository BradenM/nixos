{ config, lib, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_6_18;

    # TODO: make nvidia configurable here 

    # required for impermanence rollback in initrd
    initrd.systemd.enable = true;

    # kernel parameters
    kernelParams = [ "intel_iommu=on" "iommu=pt" ];

    # early KMS for NVIDIA
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
}
