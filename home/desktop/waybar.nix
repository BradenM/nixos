{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;

      modules-left = [
        "sway/workspaces"
        "sway/mode"
        "sway/scratchpad"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "backlight"
        "battery"
        "tray"
      ];

      "sway/workspaces" = {
        disable-scroll = false;
        all-outputs = true;
        format = "{name}";
      };

      "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };

      "sway/scratchpad" = {
        format = "{icon} {count}";
        show-empty = false;
        format-icons = [ "" "" ];
        tooltip = true;
        tooltip-format = "{app}: {title}";
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };

      "tray" = {
        spacing = 10;
      };

      "clock" = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d %H:%M}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      "cpu" = {
        format = " {usage}%";
        tooltip = true;
        interval = 2;
      };

      "memory" = {
        format = " {}%";
        interval = 2;
      };

      "temperature" = {
        critical-threshold = 80;
        format = "{icon} {temperatureC}°C";
        format-icons = [ "" "" "" ];
      };

      "backlight" = {
        format = "{icon} {percent}%";
        format-icons = [ "" "" "" "" "" "" "" "" "" ];
      };

      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = [ "" "" "" "" "" ];
      };

      "network" = {
        format-wifi = " {signalStrength}%";
        format-ethernet = " {ipaddr}";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        format-linked = " {ifname} (No IP)";
        format-disconnected = "⚠ Disconnected";
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-bluetooth = "{icon} {volume}%";
        format-bluetooth-muted = " {icon}";
        format-muted = " ";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
    }];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #cdd6f4;
        border-radius: 4px;
        margin: 2px;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.2);
      }

      #workspaces button.focused {
        background-color: #89b4fa;
        color: #1e1e2e;
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
        color: #1e1e2e;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad {
        padding: 0 10px;
        margin: 2px 2px;
        color: #cdd6f4;
        border-radius: 4px;
      }

      #battery.charging,
      #battery.plugged {
        color: #a6e3a1;
      }

      #battery.critical:not(.charging) {
        background-color: #f38ba8;
        color: #1e1e2e;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes blink {
        to {
          background-color: #cdd6f4;
          color: #1e1e2e;
        }
      }

      #temperature.critical {
        background-color: #f38ba8;
        color: #1e1e2e;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f38ba8;
      }

      #idle_inhibitor.activated {
        background-color: #cdd6f4;
        color: #1e1e2e;
      }
    '';
  };
}
