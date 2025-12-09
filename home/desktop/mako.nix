{ config, lib, pkgs, ... }:

{
  services.mako = {
    enable = true;

    settings = {
      font = "JetBrainsMono Nerd Font 10";
      width = 350;
      height = 150;
      margin = "10";
      padding = "15";
      border-size = 2;
      border-radius = 8;

      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";

      default-timeout = 5000;

      "urgency=low" = {
        border-color = "#a6adc8";
      };

      "urgency=normal" = {
        border-color = "#89b4fa";
      };

      "urgency=high" = {
        border-color = "#f38ba8";
        default-timeout = 0;
      };
    };
  };
}
