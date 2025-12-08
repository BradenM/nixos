{ config, lib, pkgs, ... }:

{
  services.mako = {
    enable = true;

    font = "JetBrainsMono Nerd Font 10";
    width = 350;
    height = 150;
    margin = "10";
    padding = "15";
    borderSize = 2;
    borderRadius = 8;

    backgroundColor = "#1e1e2e";
    textColor = "#cdd6f4";
    borderColor = "#89b4fa";

    defaultTimeout = 5000;

    extraConfig = ''
      [urgency=low]
      border-color=#a6adc8

      [urgency=normal]
      border-color=#89b4fa

      [urgency=high]
      border-color=#f38ba8
      default-timeout=0
    '';
  };
}
