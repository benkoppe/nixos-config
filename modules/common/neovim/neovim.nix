{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) enabled merge mkIf;
in
merge
<| mkIf config.isDesktop {
  home-manager.sharedModules = [
    {
      imports = [ inputs.mnw.homeManagerModules.default ];

      programs.mnw = enabled {
        luaFiles = [ ./init.lua ];

        extraBinPath = [
          pkgs.ripgrep
          pkgs.fzf

          # LSPs
          pkgs.stylua
          pkgs.nixd # nix lsp
          pkgs.nixfmt-rfc-style
          pkgs.prettierd
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

        providers = {
          nodeJs = enabled;
          perl = enabled;
          python3 = enabled;
          ruby = enabled;

        };
      };
    }
  ];
}
