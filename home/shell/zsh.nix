{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "kubectl"
        "fzf"
        "z"
        "sudo"
        "extract"
        "history"
      ];
    };

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    shellAliases = {
      # navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # modern replacements
      ls = "eza";
      ll = "eza -la";
      la = "eza -a";
      lt = "eza --tree";
      cat = "bat";

      # git shortcuts
      g = "git";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      glog = "git log --oneline --graph";

      # editor
      v = "nvim";
      vim = "nvim";
      vi = "nvim";

      # nix
      nrs = "sudo nixos-rebuild switch --flake .";
      nrb = "sudo nixos-rebuild boot --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      nfu = "nix flake update";

      # misc
      grep = "grep --color=auto";
      df = "df -h";
      du = "du -h";
      free = "free -h";

      # clipboard
      cpwd = "pwd | wl-copy -n";
      ppwd = "cd $(wl-paste)";
      wcp = "wl-copy -n";
      wpp = "wl-paste -n";
    };

    initContent = ''
      # editor
      export EDITOR="nvim"
      export VISUAL="nvim"

      # path additions
      export PATH="$HOME/.local/bin:$PATH"

      # key bindings
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # completion settings
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';
  };
}
