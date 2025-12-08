{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.pycharm-professional
    jetbrains.webstorm
  ];

  # JetBrains IDEs Wayland configuration
  home.sessionVariables = {
    # use native Wayland for JetBrains IDEs
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # JetBrains IDE settings sync persistence (stored in persistent home/.config)
}
