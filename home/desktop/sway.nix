{ config, lib, pkgs, osConfig, ... }:

let
  modifier = "Mod4";
  terminal = "alacritty";
  menu = "wofi --show drun";
in
{
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;

    config = {
      inherit modifier terminal menu;

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
        hiddenState = "hide";
        mode = "hide";
        extraConfig = "modifier Mod4";
      }];

      startup = [
        { command = "mako"; }
        { command = "wl-paste -t text -n --watch clipman store --no-persist --max-items=300"; }
        { command = "autotiling-rs"; always = true; }
        { command = "swaywsr"; always = true; }
      ];

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_options = "caps:escape";
          repeat_delay = "300";
          repeat_rate = "45";
        };

        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
          middle_emulation = "enabled";
        };

        "type:pointer" = {
          accel_profile = "flat";
        };
      };

      output = {
        "*" = {
          bg = "#1e1e2e solid_color";
        };
      } // lib.optionalAttrs (osConfig.networking.hostName == "braden-serval-ws") {
        "eDP-2" = {
          pos = "0 0";
          subpixel = "rgb";
        };
        "DP-1" = {
          pos = "2560 0";
          mode = "2560x1440@75Hz";
          subpixel = "rgb";
        };
      };

      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = true;
      };

      window = {
        titlebar = false;
        border = 2;
      };

      colors = {
        focused = {
          border = "#89b4fa";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#89b4fa";
          childBorder = "#89b4fa";
        };
        unfocused = {
          border = "#45475a";
          background = "#1e1e2e";
          text = "#bac2de";
          indicator = "#45475a";
          childBorder = "#45475a";
        };
        urgent = {
          border = "#f38ba8";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#f38ba8";
          childBorder = "#f38ba8";
        };
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+Return" = "exec ${terminal} --class AlacrittyFloat";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+g" = "exec brave";
        "${modifier}+Shift+g" = "exec firefox";

        # focus
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # move
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # resize
        "${modifier}+r" = "mode resize";

        # split
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";

        # layout
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+a" = "focus parent";
        "${modifier}+Shift+a" = "focus child";

        # workspaces
        "${modifier}+u" = "workspace back_and_forth";
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        # move to workspace
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # scratchpad
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";

        # reload/exit
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -B 'Yes' 'swaymsg exit'";

        # lock screen
        "${modifier}+Ctrl+l" = "exec swaylock -f -c 1e1e2e";

        # clipboard
        "${modifier}+p" = "exec clipman pick --tool=wofi --tool-args=\"--dmenu\"";

        # screenshots
        "Print" = "exec grim - | wl-copy";
        "Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "${modifier}+Print" = "exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";
        "${modifier}+Shift+Print" = "exec grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";

        # volume
        "XF86AudioRaiseVolume" = "exec pamixer -i 5";
        "XF86AudioLowerVolume" = "exec pamixer -d 5";
        "XF86AudioMute" = "exec pamixer -t";

        # brightness
        "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";

        # media
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        "${modifier}+n" = "exec playerctl play-pause";
        "${modifier}+Shift+n" = "exec playerctl next";
        "${modifier}+Ctrl+n" = "exec playerctl previous";

        # notifications
        "${modifier}+Shift+p" = "exec makoctl dismiss --all";
      };

      modes = {
        resize = {
          h = "resize shrink width 10 px";
          j = "resize grow height 10 px";
          k = "resize shrink height 10 px";
          l = "resize grow width 10 px";
          Left = "resize shrink width 10 px";
          Down = "resize grow height 10 px";
          Up = "resize shrink height 10 px";
          Right = "resize grow width 10 px";
          Return = "mode default";
          Escape = "mode default";
        };
      };
    };

    extraConfig = ''
      # NVIDIA-specific
      exec_always export WLR_NO_HARDWARE_CURSORS=1

      # idle management
      exec swayidle -w \
        timeout 300 'swaylock -f -c 1e1e2e' \
        timeout 600 'swaymsg "output * power off"' \
        resume 'swaymsg "output * power on"' \
        before-sleep 'swaylock -f -c 1e1e2e'

      # floating windows
      for_window [app_id="AlacrittyFloat"] floating enable
      for_window [instance="mpv"] floating enable
      for_window [app_id="mpv"] floating enable
      for_window [app_id="scrcpy"] floating enable
      for_window [app_id="blueberry.py"] floating enable
      for_window [app_id="dragon-drop"] floating enable, sticky enable
      for_window [app_id="pavucontrol"] floating enable
      for_window [title="Save File"] floating enable
      for_window [title="Open File"] floating enable

      # picture-in-picture
      for_window [title="Picture-in-Picture"] floating enable, sticky enable

      # firefox sharing indicator - hide
      for_window [title="Firefox — Sharing Indicator"] floating enable, sticky enable, move scratchpad

      # idle inhibition for video apps
      for_window [class="Microsoft Teams - Preview"] inhibit_idle fullscreen
      for_window [class="Chromium-browser"] inhibit_idle fullscreen
      for_window [class="Google-chrome"] inhibit_idle fullscreen
      for_window [app_id="firefox"] inhibit_idle fullscreen
      for_window [class="Brave-browser"] inhibit_idle fullscreen

      # prevent apps from grabbing all shortcuts
      seat * shortcuts_inhibitor disable
    '';
  };

  home.packages = with pkgs; [
    autotiling-rs
    brightnessctl
    clipman
    grim
    libnotify
    playerctl
    slurp
    swayidle
    swaylock
    swaywsr
    wf-recorder
    wl-clipboard
  ];
}
