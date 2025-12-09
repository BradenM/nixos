{ config, lib, pkgs, inputs, ... }:

let
  scriptsDir = "${inputs.dotfiles}/dotfiles/scripts";

  yoda = let
    pythonEnv = pkgs.python3.withPackages (ps: with ps; [
      liquidctl
      psutil
      docopt
    ]);
  in pkgs.writeScriptBin "yoda" ''
    #!${pythonEnv}/bin/python
    ${builtins.readFile "${scriptsDir}/yoda.py"}
  '';

  open-o = pkgs.writeShellApplication {
    name = "open-o";
    runtimeInputs = with pkgs; [ xdg-utils coreutils ];
    text = builtins.readFile "${scriptsDir}/open-o";
  };

  ots = pkgs.writeShellApplication {
    name = "ots";
    runtimeInputs = with pkgs; [ httpie jq wl-clipboard ];
    text = builtins.readFile "${scriptsDir}/ots";
  };

  wofi-csv = pkgs.writeShellApplication {
    name = "wofi-csv";
    runtimeInputs = with pkgs; [ wofi coreutils gnugrep findutils ];
    text = builtins.readFile "${scriptsDir}/wofi-csv";
  };

  launch-single = pkgs.writeShellApplication {
    name = "launch-single";
    runtimeInputs = with pkgs; [ procps coreutils ];
    text = builtins.readFile "${scriptsDir}/launch-single";
  };

  docker-stream-image = pkgs.writeShellApplication {
    name = "docker-stream-image";
    runtimeInputs = with pkgs; [ docker coreutils gzip ];
    text = builtins.readFile "${scriptsDir}/docker-stream-image";
  };

  vault-check = pkgs.writeShellApplication {
    name = "vault-check";
    runtimeInputs = with pkgs; [ vault coreutils ];
    text = builtins.readFile "${scriptsDir}/vault-check";
  };

  max-pods-calculator = pkgs.writeShellApplication {
    name = "max-pods-calculator";
    runtimeInputs = with pkgs; [ coreutils gnugrep gawk ];
    text = builtins.readFile "${scriptsDir}/max-pods-calculator.sh";
  };
in
{
  home.packages = [
    yoda
    open-o
    ots
    wofi-csv
    launch-single
    docker-stream-image
    vault-check
    max-pods-calculator
  ];
}
