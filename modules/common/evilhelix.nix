{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrValues
    elem
    enabled
    mapAttrs
    mkIf
    optionalAttrs
    ;
in
{
  home-manager.sharedModules = [
    {
      programs.helix = enabled {
        package = pkgs.evil-helix;

        languages.langugage =
          let
            formattedLanguages =
              {
                astro = "astro";
                css = "css";
                html = "html";
                javascript = "js";
                json = "json";
                jsonc = "jsonc";
                jsx = "jsx";
                markdown = "md";
                scss = "scss";
                svelte = "svelte";
                tsx = "tsx";
                typescript = "ts";
                vue = "vue";
                yaml = "yaml";
              }
              |> mapAttrs (
                name: extension:
                {
                  inherit name;

                  auto-format = true;
                  formatter.command = "deno";
                  formatter.args = [
                    "fmt"
                    "--unstable-component"
                    "--ext"
                    extension
                    "-"
                  ];
                }
                //
                  optionalAttrs
                    (elem name [
                      "javascript"
                      "jsx"
                      "typescript"
                      "tsx"
                    ])
                    {
                      language-servers = [ "deno" ];
                    }
              )
              |> attrValues;
          in
          formattedLanguages
          ++ [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "nixfmt";
            }

            {
              name = "python";
              auto-format = true;
              language-servers = [ "basedpyright" ];
            }

            {
              name = "rust";

              debugger.name = "lldb-dap";
              debugger.transport = "stdio";
              debugger.command = "lldb-dap";

              debugger.templates = [
                {
                  name = "binary";
                  request = "launch";

                  completion = [
                    {
                      name = "binary";
                      completion = "filename";
                    }
                  ];

                  args.program = "{0}";
                }
              ];
            }
          ];

        languages.language-server.deno = {
          command = "deno";
          args = [ "lsp" ];

          environment.NO_COLOR = "1";

          config.javascript = enabled {
            lint = true;
            unstable = true;

            suggest.imports.hosts."https://deno.lang" = true;

            inlayHints = {
              enumMemberValues.enabled = true;
              functionLikeReturnTypes.enabled = true;
              parameterNames.enabled = true;
              parameterTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              variableTypes.enabled = true;
            };
          };
        };

        languages.language-server.rust-analyzer = {
          config = {
            cargo.features = "all";
            check.command = "clippy";
            completion.callable.snippets = "add_parentheses";
          };
        };
      };
    }
  ];

  environment.systemPackages =
    mkIf config.isDesktop
    <| attrValues {
      inherit (pkgs)
        # CMAKE
        cmake-language-server

        # GO
        gopls

        # HTML
        vscode-langservers-extracted

        # KOTLIN
        kotlin-language-server

        # LATEX
        texlab

        # LUA
        lua-language-server

        # MARKDOWN
        markdown-oxide

        # NIX
        nixfmt-rfc-style
        nil

        # PYTHON
        basedpyright

        # RUST
        rust-analyzer-nightly
        lldb

        # TYPESCRIPT & OTHERS
        deno

        # YAML
        yaml-language-server

        # ZIG
        zls
        ;
    };
}
