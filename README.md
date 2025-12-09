# My NixOS Configuration

A general NixOS flake configuration, currently tailored for my System76 Serval WS laptop. Utilizes configurations from my existing [dotfiles](https://github.com/BradenM/dotfiles).

Features:
- Btrfs on LUKS encryption
- Impermanence (ephemeral root filesystem)
- Sway/Wayland desktop environment (seatd + auto-login)
- System76 hardware support + NVIDIA GPU + CUDA
- Home Manager for user environment
- zram swap with zstd compression
- Catppuccin theme (GTK/Qt) with Papirus icons
- VM and ISO build targets for testing

## Quick Start: Test in VM

```bash
# run the VM (builds and launches QEMU)
nix run .#vm

# login: braden / test
```

The VM includes impermanence - root (`/`) resets on each boot while `/home` and `/persist` survive.

## Quick Start: Build Live ISO

```bash
# build the ISO for hardware testing
nix build .#iso

# write to USB (replace /dev/sdX with your device)
sudo dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress

# boot and login: braden / nixos (or nixos / nixos)
```

The ISO includes the full desktop environment for testing.

## Directory Structure

```
├── flake.nix                 # main entry point
├── hosts/
│   ├── braden-serval-ws/     # System76 Serval WS config
│   │   ├── default.nix
│   │   ├── disko.nix         # LUKS + Btrfs partitioning
│   │   ├── hardware.nix
│   │   └── persistence.nix   # impermanence config
│   ├── vm/                   # VM for testing
│   │   ├── default.nix
│   │   ├── disko.nix
│   │   └── persistence.nix
│   └── iso/                  # Live ISO for hardware testing
│       └── default.nix
├── modules/
│   ├── core/                 # boot, nix, users, locale, zram, packages
│   ├── desktop/              # sway, seatd, audio, fonts
│   ├── hardware/             # system76, nvidia, cuda, bluetooth
│   └── services/             # networking (ssh, avahi), btrbk
└── home/                     # Home Manager config
    ├── shell/                # zsh (oh-my-zsh), starship, direnv, gpg
    ├── terminal/             # alacritty
    ├── editor/               # neovim + AstroNvim
    ├── desktop/              # sway, waybar, wofi, mako
    ├── apps/                 # git, dev-tools, jetbrains
    └── scripts/              # utility scripts from dotfiles
```

## Installation on Hardware

### Prerequisites

- NixOS minimal installer USB
- This repository cloned or accessible

### Step 1: Boot Installer and Prepare

```bash
# clone this repo
nix-shell -p git
git clone https://github.com/BradenM/nixos /tmp/nixos
cd /tmp/nixos
```

### Step 2: Partition Disk with Disko

```bash
# set LUKS password
echo "super-secret-password" > /tmp/disk-password

# run disko to partition and format
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko -- \
  --mode disko ./hosts/braden-serval-ws/disko.nix
```

This creates:
- `/dev/nvme0n1p1` - 1GB EFI partition → `/boot`
- `/dev/nvme0n1p2` - LUKS encrypted → Btrfs with subvolumes

### Step 3: Create Blank Snapshot for Impermanence

```bash
# mount btrfs root
sudo mount -t btrfs -o subvol=/ /dev/mapper/cryptroot /mnt

# create read-only blank snapshot
sudo btrfs subvolume snapshot -r /mnt/@root /mnt/@root-blank

sudo umount /mnt
```

### Step 4: Generate Hardware Configuration

```bash
# mount filesystems
sudo mount -t btrfs -o subvol=@root,compress=zstd,noatime /dev/mapper/cryptroot /mnt
sudo mkdir -p /mnt/{home,nix,persist,var/log,boot}
sudo mount -t btrfs -o subvol=@home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
sudo mount -t btrfs -o subvol=@nix,compress=zstd,noatime /dev/mapper/cryptroot /mnt/nix
sudo mount -t btrfs -o subvol=@persist,compress=zstd,noatime /dev/mapper/cryptroot /mnt/persist
sudo mount -t btrfs -o subvol=@log,compress=zstd,noatime /dev/mapper/cryptroot /mnt/var/log
sudo mount /dev/nvme0n1p1 /mnt/boot

# generate hardware config
sudo nixos-generate-config --root /mnt --show-hardware-config > /tmp/hardware.nix
```

Review `/tmp/hardware.nix` and merge relevant parts into target host.

### Step 5: Set User Passwords

```bash
sudo mkdir -p /mnt/persist/passwords

# set user password
echo "$(mkpasswd -m sha-512)" | sudo tee /mnt/persist/passwords/braden

# set root password (for emergency access)
echo "$(mkpasswd -m sha-512)" | sudo tee /mnt/persist/passwords/root

# secure permissions
sudo chmod 600 /mnt/persist/passwords/*
```

### Step 6: Install

```bash
sudo nixos-install --flake .#braden-serval-ws --no-root-passwd
```

### Step 7: Reboot

```bash
sudo reboot
```

## Post-Installation: Managing Your Configuration

After boot, clone the NixOS configuration to a persistent location.

### Clone Configuration

```bash
# clone to persist directory (survives impermanence resets)
git clone https://github.com/BradenM/nixos /persist/nixos

# or clone to home (also persists via @home subvolume)
git clone https://github.com/BradenM/nixos ~/nixos
```

### Making Changes

```bash
cd /persist/nixos  # or ~/nixos

# edit configuration files
nvim home/default.nix

# test changes
sudo nixos-rebuild test --flake .#braden-serval-ws

# apply changes
sudo nixos-rebuild switch --flake .#braden-serval-ws

# commit and push
git add -A && git commit -m "description of changes"
git push
```

### Configuration Locations

| Location | Persists | Notes |
|----------|----------|-------|
| `/persist/nixos` | Yes (bind-mounted) | Recommended for system config |
| `~/nixos` | Yes (@home subvolume) | Alternative location |
| `/etc/nixos` | Yes (bind-mounted) | Legacy location, not used by flakes |
| `/tmp/*` | No | Lost on reboot |

## Common Operations

### Rebuild System

```bash
# test configuration (doesn't switch)
sudo nixos-rebuild test --flake .#braden-serval-ws

# switch to new configuration
sudo nixos-rebuild switch --flake .#braden-serval-ws

# build for next boot only
sudo nixos-rebuild boot --flake .#braden-serval-ws
```

### Update Flake Inputs

```bash
# update all inputs
nix flake update

# update specific input
nix flake lock --update-input nixpkgs
```

### Rollback

```bash
# list generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# rollback to previous generation
sudo nixos-rebuild switch --rollback

# boot menu also shows previous generations
```

### Garbage Collection

```bash
# remove old generations (keeps last 14 days by default)
sudo nix-collect-garbage -d

# remove specific generations
sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system
```

## Impermanence

Root (`/`) is ephemeral - it resets to a blank state on every boot. Only explicitly declared paths persist.

### What Persists

**Via `/persist` (impermanence module):**
- `/etc/nixos` - NixOS configuration
- `/etc/NetworkManager/system-connections` - WiFi passwords
- `/etc/ssh` - SSH host keys
- `/etc/machine-id` - Machine identifier
- `/var/lib/nixos` - NixOS state
- `/var/lib/systemd` - Systemd state
- `/var/lib/bluetooth` - Bluetooth pairings

**Via dedicated subvolumes:**
- `/home` - User home directories
- `/nix` - Nix store
- `/var/log` - System logs

### How It Works

1. On boot, initrd runs a rollback script
2. The `@root` subvolume is deleted
3. A fresh `@root` is created from `@root-blank` snapshot
4. The impermanence module bind-mounts paths from `/persist`

## btrbk Snapshots

Automatic hourly snapshots via btrbk:

```bash
# list snapshots
sudo btrbk list

# show snapshot details
sudo ls -la /mnt/btrfs-root/snapshots/

# manual snapshot
sudo btrbk run
```

### Recovery from Snapshot

```bash
# mount btrfs root
sudo mount -t btrfs -o subvol=/ /dev/mapper/cryptroot /mnt

# list available snapshots
ls /mnt/snapshots/

# restore home from snapshot (example)
sudo btrfs subvolume delete /mnt/@home
sudo btrfs subvolume snapshot /mnt/snapshots/home.20240101T120000 /mnt/@home

sudo umount /mnt
sudo reboot
```

## Troubleshooting

### Impermanence Rollback Fails

```bash
# boot with init=/bin/sh
# mount and manually create blank snapshot
mount -t btrfs -o subvol=/ /dev/mapper/cryptroot /mnt
btrfs subvolume snapshot -r /mnt/@root /mnt/@root-blank
```

## Build Targets

| Target | Command | Description |
|--------|---------|-------------|
| Hardware | `nixos-rebuild switch --flake .#braden-serval-ws` | Full System76 Serval WS config |
| VM | `nix run .#vm` | QEMU VM with impermanence |
| ISO | `nix build .#iso` | Live ISO for hardware testing |

### ISO Details

The ISO is configured for testing on actual hardware before installation:
- Includes full Sway desktop with Home Manager config
- Manual TTY login (no auto-login), run `sway` after login to start desktop
- Login as `braden` (password: `nixos`) for full desktop
- Login as `nixos` (password: `nixos`) for basic testing
- SSH enabled for remote access (root login allowed for installation)
