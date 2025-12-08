{ config, lib, pkgs, ... }:

{
  programs.wofi = {
    enable = true;

    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };

    style = ''
      window {
        margin: 0px;
        border: 2px solid #89b4fa;
        border-radius: 8px;
        background-color: #1e1e2e;
      }

      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4;
        background-color: #313244;
        border-radius: 4px;
        padding: 10px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }

      #entry {
        margin: 2px;
        border: none;
        border-radius: 4px;
        background-color: transparent;
      }

      #entry:selected {
        background-color: #89b4fa;
        color: #1e1e2e;
      }

      #entry:selected #text {
        color: #1e1e2e;
      }
    '';
  };
}
