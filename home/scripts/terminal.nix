{ config, lib, pkgs, inputs, ... }:

let
  scriptsDir = "${inputs.dotfiles}/dotfiles/scripts";
  utilsContent = builtins.readFile "${scriptsDir}/utils.bash";

  alacritty-adjust = pkgs.writeShellApplication {
    name = "alacritty-adjust";
    runtimeInputs = with pkgs; [ sway jq alacritty ];
    text = builtins.readFile "${scriptsDir}/alacritty-adjust";
  };

  alacritty-float = pkgs.writeShellApplication {
    name = "alacritty-float";
    runtimeInputs = with pkgs; [ sway jq alacritty gawk coreutils ];
    text = builtins.readFile "${scriptsDir}/alacritty-float";
  };

  ssh-copy-terminfo = pkgs.writeShellApplication {
    name = "ssh-copy-terminfo";
    runtimeInputs = with pkgs; [ openssh ncurses ];
    text = ''
      ${utilsContent}
      ${builtins.replaceStrings
        [ ". utils.bash" ]
        [ "" ]
        (builtins.readFile "${scriptsDir}/ssh-copy-terminfo")}
    '';
  };

in
{
  home.packages = [
    alacritty-adjust
    alacritty-float
    ssh-copy-terminfo
  ];
}
