{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-L" "nixos" ];

                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" "autodefrag" "ssd" "discard=async" "space_cache=v2" "commit=120" ];
                  };

                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" "autodefrag" "ssd" "discard=async" "space_cache=v2" "commit=120" ];
                  };

                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" "autodefrag" "ssd" "discard=async" "space_cache=v2" "commit=120" ];
                  };

                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" "noatime" "autodefrag" "ssd" "discard=async" "space_cache=v2" "commit=120" ];
                  };

                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" "autodefrag" "ssd" "discard=async" "space_cache=v2" "commit=120" ];
                  };

                  "@build" = {
                    mountpoint = "/build";
                    mountOptions = [ "compress=zstd" "noatime" "autodefrag" "ssd" "discard=async" "space_cache=v2" "commit=120" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
