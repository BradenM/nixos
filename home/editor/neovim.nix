{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      # LSP servers
      nil
      lua-language-server
      pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      rust-analyzer
      gopls
      marksman

      # formatters
      stylua
      black
      isort
      nixpkgs-fmt
      nodePackages.prettier
      shfmt

      # linters
      shellcheck
      eslint_d

      # utilities for treesitter, LSP, etc.
      tree-sitter
      gcc
      gnumake
      nodejs
      cargo
      unzip
      wget
      curl
      fd
      ripgrep

      # clipboard support
      wl-clipboard
    ];
  };

  # AstroNvim configuration
  # this clones AstroNvim template and your user config can be added
  xdg.configFile."nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "AstroNvim";
      repo = "template";
      rev = "main";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    recursive = true;
  };

  # NOTE: After first build, you'll need to:
  # 1. Get the correct sha256 by attempting to build (nix will show actual hash)
  # 2. Or clone manually: git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
  # 3. Then customize lua/user/ directory for your AstroNvim configuration
  # 4. Alternatively, reference your existing nvim config from your dotfiles repo

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
