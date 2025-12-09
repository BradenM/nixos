{ config, lib, pkgs, inputs, ... }:

let
  scriptsDir = "${inputs.dotfiles}/dotfiles/scripts";

  web-search = pkgs.writeShellApplication {
    name = "web-search";
    runtimeInputs = with pkgs; [ wofi xdg-utils ];
    text = builtins.readFile "${scriptsDir}/web_search";
  };

  ssh-cipher-benchmark = pkgs.writeShellApplication {
    name = "ssh-cipher-benchmark";
    runtimeInputs = with pkgs; [ openssh coreutils ];
    excludeShellChecks = [ "SC2005" "SC2046" "SC2086" "SC2124" "SC2181" "SC2196" ];
    text = builtins.readFile "${scriptsDir}/ssh-cipher-benchmark.sh";
  };

  subdom-port-scan = pkgs.writeShellApplication {
    name = "subdom-port-scan";
    runtimeInputs = with pkgs; [ nmap coreutils ];
    excludeShellChecks = [ "SC2006" "SC2013" "SC2086" ];
    text = builtins.readFile "${scriptsDir}/subdom-port-scan.sh";
  };
in
{
  home.packages = [
    web-search
    ssh-cipher-benchmark
    subdom-port-scan
  ];
}
