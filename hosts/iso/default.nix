{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"

    ../../modules/core
    ../../modules/hardware
    ../../modules/desktop
    ../../modules/services
  ];

  nixpkgs.config.allowUnfree = true;

  # disable ZFS (broken on latest kernel, we use Btrfs anyway)
  boot.supportedFilesystems.zfs = lib.mkForce false;

  # override boot timeout (ISO default is 10)
  boot.loader.timeout = lib.mkForce 10;

  # override braden user password (no /persist on ISO)
  users.users.braden.hashedPasswordFile = lib.mkForce null;
  users.users.braden.initialPassword = lib.mkForce "nixos";

  # disable btrbk (no btrfs mounts on ISO)
  services.btrbk.instances = lib.mkForce {};

  # disable btrfs-root mount (doesn't exist on ISO)
  fileSystems."/mnt/btrfs-root" = lib.mkForce { device = "none"; fsType = "none"; options = [ "noauto" ]; };

  # override NVIDIA env vars for ISO (use default GPU handling)
  # omit GBM_BACKEND, __GLX_VENDOR_LIBRARY_NAME, LIBVA_DRIVER_NAME to avoid sway NVIDIA check
  environment.sessionVariables = lib.mkForce {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # ISO-specific settings
  isoImage = {
    volumeID = lib.mkForce "NIXOS_ISO";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
  image.fileName = lib.mkForce "nixos-serval-ws-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso";

  # live user for testing
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "seat" ];
    initialHashedPassword = lib.mkForce null;
    initialPassword = lib.mkForce "nixos";
    shell = pkgs.zsh;
  };

  # disable auto-login and auto-start sway (manual TTY login for ISO)
  services.getty.autologinUser = lib.mkForce null;
  environment.loginShellInit = lib.mkForce "";

  # additional packages for installation (disk tools already in core/packages.nix)
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    htop
  ];

  # override SSH for ISO (allow root login with password for installation)
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  # set root password for emergency access
  users.users.root = {
    initialHashedPassword = lib.mkForce null;
    initialPassword = lib.mkForce "nixos";
  };

  system.stateVersion = "25.11";
}
