{ config, lib, pkgs, ... }:

{
  fileSystems."/persist".neededForBoot = true;

  # blank snapshot rollback service (same as real hardware, but no LUKS)
  boot.initrd.systemd.services.rollback = {
    description = "Rollback Btrfs root to blank snapshot";
    wantedBy = [ "initrd.target" ];
    after = [ "local-fs-pre.target" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt

      # mount the btrfs root (no LUKS in VM)
      mount -t btrfs -o subvol=/ /dev/vda2 /mnt

      # delete any nested subvolumes in @root
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

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /persist/etc 0755 root root"
    "d /persist/var/lib 0755 root root"
  ];
}
