{ config, lib, pkgs, inputs, ... }:

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
        "aws"
        "python"
        "rsync"
        "pip"
        "npm"
        "yarn"
        "rust"
        "golang"
        "helm"
        "terraform"
        "ansible"
        "systemd"
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
      ls = "eza --icons --git";
      ll = "eza -la";
      la = "eza -a";
      lt = "eza --tree";
      l = "ls";
      cat = "bat";
      rm = "trash";

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
      c = "clear";
      j = "z";
      ssh = "TERM=xterm-256color command ssh";
      ssha = "eval $(ssh-agent)";
      cls = ''stat -c "%a %n" *'';
      errors = "journalctl -b -p err|less";

      # clipboard
      cpwd = "pwd | wl-copy -n";
      ppwd = "cd $(wl-paste)";
      wcp = "wl-copy -n";
      wpp = "wl-paste -n";
      wpick = ''clipman pick --print0 --tool=CUSTOM --tool-args="fzf --prompt 'pick > ' --bind 'tab:up' --cycle --read0"'';

      # ip helpers
      wanip = "curl -s -X GET https://checkip.amazonaws.com";

      # mise
      m = "mise";
      x = "mise exec --";
      r = "mise run --";
      dallow = "mise exec direnv -- direnv allow";

      # pnpm
      p = "pnpm";

      # config shortcuts
      zshcfg = "$EDITOR ~/.config/zsh";
      vimrc = "$EDITOR ~/.config/nvim";
      swaycfg = "$EDITOR ~/.config/sway";
    };

    initContent = let
      zshCustom = "${inputs.dotfiles}/dotfiles/oh-my-zsh/custom";
    in ''
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

      # source custom functions from dotfiles
      source "${zshCustom}/aws.zsh"
      source "${zshCustom}/io.zsh"
      source "${zshCustom}/sway.zsh"
      source "${zshCustom}/git.zsh"
      unalias lg 2>/dev/null || true  # remove alias so lazygit module can define lg() function
      source "${zshCustom}/utils.zsh"

      # inline functions from aliases.zsh
      takeown() { sudo -E chown -R "''${USER}:''${USER}" "$@"; }
      eshell() { xdg-open "https://explainshell.com/explain?cmd=$1"; }
      timeit() { /usr/bin/time -f "| Real: %es | User: %Us | Sys: %Ss |" "$@"; }
    '';
  };
}
