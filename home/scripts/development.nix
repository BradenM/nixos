{ config, lib, pkgs, inputs, ... }:

let
  scriptsDir = "${inputs.dotfiles}/dotfiles/scripts";
  utilsContent = builtins.readFile "${scriptsDir}/utils.bash";

  git-dir-download = pkgs.writeShellApplication {
    name = "git-dir-download";
    runtimeInputs = with pkgs; [ subversion coreutils ncurses ];
    excludeShellChecks = [ "SC2086" "SC2162" "SC2178" ];
    text = ''
      ${utilsContent}
      ${builtins.replaceStrings
        [ ". utils.bash" ]
        [ "" ]
        (builtins.readFile "${scriptsDir}/git-dir-download")}
    '';
  };

  git-search-stash = pkgs.writeShellApplication {
    name = "git-search-stash";
    runtimeInputs = with pkgs; [ git gawk gnugrep ncurses ];
    excludeShellChecks = [ "SC2086" "SC2162" "SC2178" ];
    text = ''
      ${utilsContent}
      ${builtins.replaceStrings
        [ ". utils.bash" ]
        [ "" ]
        (builtins.readFile "${scriptsDir}/git-search-stash")}
    '';
  };

  rgreplace = pkgs.writeShellApplication {
    name = "rgreplace";
    runtimeInputs = with pkgs; [ ripgrep gnused ncurses ];
    excludeShellChecks = [ "SC2086" "SC2162" "SC2178" ];
    text = ''
      ${utilsContent}
      ${builtins.replaceStrings
        [ ". utils.bash" ]
        [ "" ]
        (builtins.readFile "${scriptsDir}/rgreplace")}
    '';
  };

  envjson = pkgs.writers.writePython3Bin "envjson" {
    libraries = [ ];
    flakeIgnore = [ "E722" ];
  } (builtins.replaceStrings
    [ "#!/usr/bin/env python3\n" ]
    [ "" ]
    (builtins.readFile "${scriptsDir}/envjson"));

  flatstring = pkgs.writeShellApplication {
    name = "flatstring";
    runtimeInputs = with pkgs; [ coreutils gnused ];
    text = builtins.readFile "${scriptsDir}/flatstring";
  };
in
{
  home.packages = [
    git-dir-download
    git-search-stash
    rgreplace
    envjson
    flatstring
  ];
}
