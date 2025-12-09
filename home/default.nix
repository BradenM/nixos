{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # shell
    ./shell/zsh.nix
    ./shell/starship.nix
    ./shell/direnv.nix
    ./shell/gpg.nix

    # terminal
    ./terminal/alacritty.nix

    # editor
    ./editor/neovim.nix

    # desktop
    ./desktop/sway.nix
    ./desktop/waybar.nix
    ./desktop/wofi.nix
    ./desktop/mako.nix

    # apps
    ./apps/git.nix
    ./apps/dev-tools.nix
    ./apps/jetbrains.nix

    # scripts
    ./scripts
  ];

  home = {
    username = "braden";
    homeDirectory = "/home/braden";
    stateVersion = "25.11";
  };

  # persistence for impermanence
  home.persistence."/persist/home/braden" = {
    directories = [
      ".local/share/nvim"
      ".local/state/nvim"
      ".cache/nvim"
      ".config/gh"
      ".config/lazygit"
    ];
    allowOther = true;
  };

  programs.home-manager.enable = true;

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt theme (match GTK)
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  # cursor theme for Wayland
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "brave";
    TERMINAL = "alacritty";
  };

  # common packages
  home.packages = with pkgs; [
    # browsers
    firefox-bin
    brave

    # communication
    slack

    # media
    mpv
    imv

    # file manager
    pcmanfm

    # utilities
    gnome-keyring
    libsecret
  ];
}
