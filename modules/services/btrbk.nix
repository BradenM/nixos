{ config, lib, pkgs, ... }:

{
  services.btrbk.instances = {
    snapshots = {
      onCalendar = "hourly";
      settings = {
        timestamp_format = "long";
        snapshot_preserve_min = "2d";
        snapshot_preserve = "7d 4w 6m";

        volume."/mnt/btrfs-root" = {
          snapshot_dir = "snapshots";

          subvolume."@home" = {
            snapshot_name = "home";
          };

          subvolume."@persist" = {
            snapshot_name = "persist";
          };
        };
      };
    };
  };

  # mount btrfs root for btrbk access to all subvolumes
  fileSystems."/mnt/btrfs-root" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=/" "compress=zstd" "noatime" ];
  };

  environment.systemPackages = with pkgs; [
    btrbk
    btrfs-progs
  ];
}
