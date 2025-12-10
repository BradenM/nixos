{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Braden Mars";
        email = "bradenmars@bradenmars.me";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
      };

      color = {
        ui = "auto";
        diff = "auto";
        status = "auto";
        branch = "auto";
      };

      credential.helper = "store";

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        ca = "commit --amend";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --oneline --graph --decorate";
        lga = "log --oneline --graph --decorate --all";
        df = "diff";
        dfs = "diff --staged";
        undo = "reset --soft HEAD^";
        wip = "!git add -A && git commit -m 'WIP'";
      };
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      "*.swo"
      "*~"
      ".idea/"
      ".vscode/"
      "*.pyc"
      "__pycache__/"
      ".env"
      ".envrc"
      ".direnv/"
      "node_modules/"
      ".mypy_cache/"
      ".pytest_cache/"
      "*.egg-info/"
      "dist/"
      "build/"
      ".tox/"
      "venv/"
      ".venv/"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = false;
      line-numbers = true;
      syntax-theme = "Catppuccin Mocha";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      reporting = "off";
      gui = {
        theme = {
          lightTheme = false;
          activeBorderColor = [ "#89b4fa" "bold" ];
          inactiveBorderColor = [ "#a6adc8" ];
          searchingActiveBorderColor = [ "#f9e2af" "bold" ];
          optionsTextColor = [ "#89b4fa" ];
          selectedLineBgColor = [ "#313244" ];
          selectedRangeBgColor = [ "#313244" ];
          cherryPickedCommitBgColor = [ "#45475a" ];
          cherryPickedCommitFgColor = [ "#89b4fa" ];
          unstagedChangesColor = [ "#f38ba8" ];
        };
        showFileTree = true;
        showRandomTip = false;
        showCommandLog = true;
        showIcons = true;
      };
      git = {
        commit = {
            signOff = true;
        };
        pagers = [{
          colorArg = "always";
          pager = "delta --dark --paging=never --diff-so-fancy --line-numbers";
          useConfig = false;
        }];
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
