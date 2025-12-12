{ config, lib, pkgs, ... }:

{
  # symlink to default config path so btrbk works without -c flag
  environment.etc."btrbk/btrbk.conf".source = "/etc/btrbk/snapshots.conf";

  # create snapshots subvolume if it doesn't exist
  system.activationScripts.btrbk-snapshots-init.text = ''
    if [ ! -d /mnt/btrfs-root/snapshots ]; then
      ${pkgs.btrfs-progs}/bin/btrfs subvolume create /mnt/btrfs-root/snapshots
    fi
  '';

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
