{ config, lib, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    # see:
    # https://github.com/NixOS/nixpkgs/issues/467814#issuecomment-3620802561
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    nvidiaSettings = true;
  };

  environment.sessionVariables = {
    # Wayland support for various toolkits
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";

    # NVIDIA-specific Wayland settings
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";

    # fix cursor issues on wlroots compositors
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
