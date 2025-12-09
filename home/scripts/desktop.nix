{ config, lib, pkgs, inputs, ... }:

let
  scriptsDir = "${inputs.dotfiles}/dotfiles/scripts";
  swayScriptsDir = "${inputs.dotfiles}/dotfiles/config/sway/scripts";

  lock = pkgs.writeShellApplication {
    name = "lock";
    runtimeInputs = [ pkgs.swaylock ];
    text = builtins.readFile "${swayScriptsDir}/lock.sh";
  };

  select-area = pkgs.writeShellApplication {
    name = "select-area";
    runtimeInputs = with pkgs; [ sway jq slurp libnotify ];
    text = builtins.readFile "${scriptsDir}/select-area";
  };

  sway-prop = pkgs.writeShellApplication {
    name = "sway-prop";
    runtimeInputs = with pkgs; [ sway jq kitty ];
    excludeShellChecks = [ "SC2016" "SC2034" "SC2064" "SC2086" ];
    text = builtins.readFile "${scriptsDir}/sway-prop";
  };

  swytch = pkgs.writeShellApplication {
    name = "swytch";
    runtimeInputs = with pkgs; [ sway jq wofi gawk coreutils ];
    excludeShellChecks = [ "SC2034" "SC2004" "SC2086" ];
    text = builtins.readFile "${scriptsDir}/swytch";
  };

  screenrec = pkgs.writeShellApplication {
    name = "screenrec";
    runtimeInputs = with pkgs; [ sway wf-recorder coreutils ];
    text = builtins.replaceStrings
      [ "$(~/.scripts/select-area)" ]
      [ "$(${select-area}/bin/select-area)" ]
      (builtins.readFile "${swayScriptsDir}/screenrec.sh");
  };

  stopscreenrec = pkgs.writeShellApplication {
    name = "stopscreenrec";
    runtimeInputs = with pkgs; [ procps ];
    text = builtins.readFile "${swayScriptsDir}/stopscreenrec.sh";
  };

  autotiling = pkgs.writeShellApplication {
    name = "autotiling";
    runtimeInputs = [ pkgs.autotiling ];
    text = builtins.readFile "${swayScriptsDir}/autotiling.sh";
  };

  import-gsettings = pkgs.writeShellApplication {
    name = "import-gsettings";
    runtimeInputs = with pkgs; [ gnome-settings-daemon glib gnused ];
    excludeShellChecks = [ "SC2034" "SC2059" ];
    text = builtins.readFile "${scriptsDir}/import-gsettings";
  };

  electron-wayland = pkgs.writeShellApplication {
    name = "electron-wayland";
    runtimeInputs = [ ];
    text = builtins.readFile "${scriptsDir}/electron-wayland";
  };
in
{
  home.packages = [
    lock
    select-area
    sway-prop
    swytch
    screenrec
    stopscreenrec
    autotiling
    import-gsettings
    electron-wayland
  ];
}
