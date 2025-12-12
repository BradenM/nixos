{ config, lib, pkgs, ... }:

{
  # ensure persist is available early in boot
  fileSystems."/persist".neededForBoot = true;

  # allow FUSE mounts with allow_other (needed for home-manager impermanence)
  programs.fuse.userAllowOther = true;

  # blank snapshot rollback service
  boot.initrd.systemd.services.rollback = {
    description = "Rollback Btrfs root to blank snapshot";
    wantedBy = [ "initrd.target" ];
    after = [ "systemd-cryptsetup@cryptroot.service" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt

      # mount the btrfs root
      mount -t btrfs -o subvol=/ /dev/mapper/cryptroot /mnt

      # if we have any subvolumes in @root, delete them
      btrfs subvolume list -o /mnt/@root 2>/dev/null |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "Deleting subvolume: $subvolume"
          btrfs subvolume delete "/mnt/$subvolume"
        done || true

      # delete @root and restore from @root-blank
      echo "Deleting @root subvolume..."
      btrfs subvolume delete /mnt/@root || true

      echo "Creating fresh @root from @root-blank snapshot..."
      btrfs subvolume snapshot /mnt/@root-blank /mnt/@root

      umount /mnt
    '';
  };

  # impermanence configuration
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"

      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/bluetooth"
      "/var/lib/system76-power"

    ];

    files = [
      "/etc/machine-id"
      "/etc/adjtime"
    ];
  };

  # create required persist directories
  systemd.tmpfiles.rules = [
    "d /persist/passwords 0700 root root"
    "d /persist/etc 0755 root root"
    "d /persist/var/lib 0755 root root"
    "L /home/bradenmars - - - - /home/braden"
  ];
}
