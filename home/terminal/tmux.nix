{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "Escape";
    terminal = "screen-256color";
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      copycat
      yank
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      vim-tmux-navigator
    ];

    extraConfig = ''
      # prefix bindings
      bind-key Escape last-window

      # terminal overrides for true color
      set-option -sa terminal-overrides ",alacritty:RGB"

      # activity monitoring
      set -g visual-activity on

      # direnv support
      set-option -g update-environment "DIRENV_DIFF DIRENV_DIR DIRENV_WATCHES"
      set-environment -gu DIRENV_DIFF
      set-environment -gu DIRENV_DIR
      set-environment -gu DIRENV_WATCHES
      set-environment -gu DIRENV_LAYOUT
    '';
  };
}
