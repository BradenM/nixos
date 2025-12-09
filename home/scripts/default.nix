{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./desktop.nix
    ./media.nix
    ./cloud.nix
    ./development.nix
    ./system.nix
    ./terminal.nix
    ./network.nix
    ./misc.nix
  ];
}
