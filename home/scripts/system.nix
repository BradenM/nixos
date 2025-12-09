{ config, lib, pkgs, inputs, ... }:

let
  scriptsDir = "${inputs.dotfiles}/dotfiles/scripts";

  mount-chroot = pkgs.writeShellApplication {
    name = "mount-chroot";
    runtimeInputs = with pkgs; [ util-linux coreutils ];
    text = builtins.readFile "${scriptsDir}/mount-chroot";
  };

  ls-iommu = pkgs.writeShellApplication {
    name = "ls-iommu";
    runtimeInputs = with pkgs; [ pciutils findutils coreutils ];
    text = builtins.readFile "${scriptsDir}/ls-iommu.sh";
  };

  dump-pci-pwr = pkgs.writeShellApplication {
    name = "dump-pci-pwr";
    runtimeInputs = with pkgs; [ pciutils coreutils gnugrep ];
    text = builtins.readFile "${scriptsDir}/dump-pci-pwr.sh";
  };

  virsh-bridge = pkgs.writeShellApplication {
    name = "virsh-bridge";
    runtimeInputs = with pkgs; [ bridge-utils dhcpcd ];
    text = builtins.readFile "${scriptsDir}/virsh-bridge";
  };

  mntnas = pkgs.writeShellApplication {
    name = "mntnas";
    runtimeInputs = with pkgs; [ util-linux coreutils ];
    text = builtins.readFile "${scriptsDir}/mntnas";
  };

  clear-fc-cache = pkgs.writeShellApplication {
    name = "clear-fc-cache";
    runtimeInputs = with pkgs; [ fontconfig ];
    text = builtins.readFile "${scriptsDir}/clear-fc-cache";
  };

  kill-all-by = pkgs.writeShellApplication {
    name = "kill-all-by";
    runtimeInputs = with pkgs; [ procps ];
    text = builtins.readFile "${scriptsDir}/kill-all-by";
  };

  color-test = pkgs.writeShellApplication {
    name = "24-bit-color";
    runtimeInputs = [ ];
    text = builtins.readFile "${scriptsDir}/24-bit-color.sh";
  };
in
{
  home.packages = [
    mount-chroot
    ls-iommu
    dump-pci-pwr
    virsh-bridge
    mntnas
    clear-fc-cache
    kill-all-by
    color-test
  ];
}
