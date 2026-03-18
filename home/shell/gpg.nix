{ config, lib, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    settings = {
      use-agent = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-bemenu;
    defaultCacheTtl = 3600;
    maxCacheTtl = 7200;
  };
}
