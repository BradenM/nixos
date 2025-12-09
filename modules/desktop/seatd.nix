{ config, lib, pkgs, ... }:

{
  services.seatd.enable = true;

  # auto-login for braden user on tty1
  services.getty.autologinUser = "braden";

  # auto-start sway on tty1 login
  environment.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway --unsupported-gpu
    fi
  '';
}
