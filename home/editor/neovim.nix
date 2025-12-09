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
      rev = "89ebfd35d6415634d82cc6f2991bf66c842872d0";
      sha256 = "sha256-nxPdSG4TMpNwB8d4s3Iw/uULZgx04HBYf+QSwZXQyH8=";
    };
    recursive = true;
  };

  # pre-install lazy.nvim so it doesn't need to bootstrap via git
  xdg.dataFile."nvim/lazy/lazy.nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "lazy.nvim";
      rev = "v11.17.5";
      sha256 = "sha256-h5404njTAfqMJFQ3MAr2PWSbV81eS4aIs0cxAXkT0EM=";
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
