{ inputs, config, lib, pkgs, dotfiles, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    imports = [ inputs.mnw.homeManagerModules.default ];

    programs.mnw = enabled {
      luaFiles = [ ./init.lua ];

      extraBinPath = [
	      pkgs.ripgrep
	      pkgs.fzf
        pkgs.stylua
      ];

      plugins = {
	start = [
	  pkgs.vimPlugins.lazy-nvim
	  pkgs.vimPlugins.plenary-nvim
	];

	dev.myconfig = {
	  pure = ./.;
	  impure = "/home/test/.nixos-config/modules/common/neovim";
	};
      };
    };
  }];
}
