{ config, lib, pkgs, inputs, ... }:

let
  scriptsDir = "${inputs.dotfiles}/dotfiles/scripts";
  utilsContent = builtins.readFile "${scriptsDir}/utils.bash";

  aws-export-zone = pkgs.writeShellApplication {
    name = "aws-export-zone";
    runtimeInputs = with pkgs; [ awscli2 jq coreutils ];
    text = builtins.readFile "${scriptsDir}/aws-export-zone";
  };

  aws-delete-ami = pkgs.writeShellApplication {
    name = "aws-delete-ami";
    runtimeInputs = with pkgs; [ awscli2 ncurses ];
    text = ''
      ${utilsContent}
      ${builtins.replaceStrings
        [ ". utils.bash" ]
        [ "" ]
        (builtins.readFile "${scriptsDir}/aws-delete-ami")}
    '';
  };

  aws-pager = pkgs.writeShellApplication {
    name = "aws-pager";
    runtimeInputs = with pkgs; [ less ];
    text = builtins.readFile "${scriptsDir}/aws-pager";
  };

  s3-presign = pkgs.writers.writePython3Bin "s3-presign" {
    libraries = with pkgs.python3Packages; [ boto3 requests ];
  } (builtins.readFile "${scriptsDir}/s3-presign.py");
in
{
  home.packages = [
    aws-export-zone
    aws-delete-ami
    aws-pager
    s3-presign
  ];
}
