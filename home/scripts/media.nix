{ config, lib, pkgs, inputs, ... }:

let
  scriptsDir = "${inputs.dotfiles}/dotfiles/scripts";

  ffmpeg-gif = pkgs.writeShellApplication {
    name = "ffmpeg-gif";
    runtimeInputs = [ pkgs.ffmpeg ];
    excludeShellChecks = [ "SC2028" ];
    text = builtins.readFile "${scriptsDir}/ffmpeg-gif";
  };

  mkclip = pkgs.writeShellApplication {
    name = "mkclip";
    runtimeInputs = with pkgs; [
      ffmpeg
      awscli2
      imagemagick
      file
      wl-clipboard
      coreutils
    ];
    excludeShellChecks = [ "SC2034" "SC2086" ];
    text = builtins.readFile "${scriptsDir}/mkclip";
  };

  srecord = pkgs.writeShellApplication {
    name = "srecord";
    runtimeInputs = with pkgs; [ wf-recorder coreutils libnotify mpv ];
    excludeShellChecks = [ "SC2034" "SC2154" "SC2162" ];
    text = builtins.readFile "${scriptsDir}/srecord";
  };

  xdp-screen-cast = let
    pythonEnv = pkgs.python3.withPackages (ps: with ps; [
      dbus-python
      pygobject3
    ]);
  in pkgs.writeScriptBin "xdp-screen-cast" ''
    #!${pythonEnv}/bin/python3
    ${builtins.readFile "${scriptsDir}/xdp-screen-cast.py"}
  '';
in
{
  home.packages = [
    ffmpeg-gif
    mkclip
    srecord
    xdp-screen-cast
  ];
}
