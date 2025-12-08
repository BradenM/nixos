{ config, lib, pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = true;
  };

  # realtime scheduling for audio
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    playerctl
    pamixer
  ];
}
