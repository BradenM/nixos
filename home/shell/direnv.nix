{ config, lib, pkgs, inputs, ... }:

let
  direnvDir = "${inputs.dotfiles}/dotfiles/config/direnv";
  direnvRcContent = builtins.readFile "${direnvDir}/direnvrc";
in
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      global = {
        warn_timeout = "30s";
        hide_env_diff = true;
      };
    };

    # stdlib = direnvRcContent;
    stdlib = ''
      ${direnvRcContent}

# Export a function in direnv environment.
# Extension of: https://github.com/direnv/direnv/issues/73#issuecomment-152284914
# with support for specifying execution shell
export_function() {
	local name=$1
	local sh="${"$"}{2:-$SHELL}"
	local alias_dir="$(direnv_layout_dir)/aliases"
	mkdir -p "$alias_dir"
	PATH_add "$alias_dir"
	local target="$alias_dir/$name"
	if declare -f "$name" >/dev/null; then
		#echo "#!$SHELL" >"$target"
		echo "#!/usr/bin/env $(basename "$sh")" >"$target"
		declare -f "$name" >>"$target" 2>/dev/null
		# Notice that we add shell variables to the function trigger.
		echo "$name \$*" >>"$target"
		chmod +x "$target"
	fi
}

      
    '';

  };
}
