{ inputs, config, lib, pkgs, dotfiles, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    imports = [ inputs.mnw.homeManagerModules.default ];

    programs.mnw = enabled {
      luaFiles = [];

      extraBinPath = [
	pkgs.ripgrep
	pkgs.fzf
      ];

      plugins = {
	start = [
	  pkgs.vimPlugins.lazy-nvim
	  pkgs.vimPlugins.plenary-nvim
	];

	dev.myconfig = {
	  pure = ./.;
	  impure = 
	    # This is a hack, it should be an absolute path
	    # here it'll only work from this directory
	    "/' .. vim.uv.cwd()";
	};
      };
    };
  }];
}
