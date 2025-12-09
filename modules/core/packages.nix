{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # disk management
    parted
    gptfdisk
    btrfs-progs
    cryptsetup
  ];
}
