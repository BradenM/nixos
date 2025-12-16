{ config, lib, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      grim
      slurp
      mako
      wofi
      libnotify
    ];

    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
    '';
  };

  # wayland environment variables
  environment.sessionVariables = {
    # electron/chromium
    NIXOS_OZONE_WL = "1";
    # mozilla
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DBUS_REMOTE = "1";
    # qt
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # clutter
    CLUTTER_BACKEND = "wayland";
    # xdg
    XDG_CURRENT_DESKTOP = "sway";
    # wlroots
    WLR_NO_HARDWARE_CURSORS = "1";
    # java
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  security.pam.services.swaylock = {};
  security.polkit.enable = true;

  # polkit agent for GUI authentication prompts
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # XDG portals for screen sharing, file dialogs, etc.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];
}
