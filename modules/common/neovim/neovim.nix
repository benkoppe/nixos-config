{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    enabled
    merge
    mkIf
    attrValues
    optionalAttrs
    ;
in
merge
<| mkIf config.isDesktop {
  environment = {
    variables.EDITOR = "nvim";
  };

  home-manager.sharedModules = [
    {
      imports = [ inputs.mnw.homeManagerModules.default ];

      programs.mnw = enabled {
        aliases = [
          "vi"
          "vim"
        ];

        luaFiles = [ ./init.lua ];

        extraBinPath =
          attrValues
          <|
            {
              inherit (pkgs)
                ripgrep
                fzf
                xclip

                ## LSPs & formatters (this is basically mason)

                # general formatter
                prettierd

                # lua
                stylua
                lua-language-server

                # nix
                nixd
                nixfmt-rfc-style

                # python
                black
                pyright
                basedpyright
                ruff

                # go
                gopls
                gofumpt
                gotools

                # docker
                dockerfile-language-server-nodejs
                docker-compose-language-service

                # webdev
                svelte-language-server
                tailwindcss-language-server
                vue-language-server
                vtsls # typescript
                typescript-language-server
                javascript-typescript-langserver

                # rust
                rust-analyzer
                lldb

                # random
                bash-language-server
                yaml-language-server
                vscode-langservers-extracted

                csharpier
                ktlint
                markdownlint-cli2
                rubocop
                shfmt
                sqlfluff
                ;

              # these packages must be imported differently
              inherit (pkgs.rubyPackages) erb-formatter;
              inherit (pkgs.php83Packages) php-cs-fixer;
            }
            # clipboard management for linux
            // optionalAttrs config.isLinux {
              inherit (pkgs) wl-clipboard;
            };

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
