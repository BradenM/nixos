{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # modern CLI tools
    ripgrep
    fd
    bat
    eza
    zoxide
    fzf
    jq
    yq-go
    httpie

    # development utilities
    gnumake
    cmake
    pkg-config

    # archive tools
    unzip
    zip
    p7zip

    # network tools
    curl
    wget
    nmap
    dig

    # monitoring
    htop
    btop
    ncdu

    # misc utilities
    tree
    tldr
    neofetch
    tokei

    # container tools
    docker-compose
    kubectl
    k9s

    # nix tools
    nix-tree
    nix-diff
    nixpkgs-fmt
    nil
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
      "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
      "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    ];

    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "numbers,changes,header";
    };
    themes = {
      "Catppuccin Mocha" = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d714cc1d358ea51bfc02550f6b8f3c308e60ac6c";
          sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };
}
