{ config, lib, pkgs, inputs, ... }:

let
  direnvDir = "${inputs.dotfiles}/dotfiles/config/direnv";
  direnvRcContent = builtins.readFile "${direnvDir}/direnvrc";
in
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      global = {
        warn_timeout = "30s";
        hide_env_diff = true;
      };
    };

    stdlib = direnvRcContent;

  };
}
