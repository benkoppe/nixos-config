{
  lib,
  dotfiles,
  ...
}:
let
  inherit (lib) enabled;
in
{
  environment.shellAliases."nix-develop" = "nix develop -c $SHELL";

  programs.zsh = enabled;

  home-manager.sharedModules = [
    {
      programs.zsh = enabled {
        oh-my-zsh = enabled {
          plugins = [
            "git"
            "sudo"
          ];
        };

        antidote = enabled {
          useFriendlyNames = true;
          plugins = [
            ''
              zdharma-continuum/fast-syntax-highlighting kind:defer
              zsh-users/zsh-history-substring-search
              zsh-users/zsh-autosuggestions
              unixorn/jpb.zshplugin
              unixorn/warhol.plugin.zsh
              unixorn/tumult.plugin.zsh
              eventi/noreallyjustfuckingstopalready
              djui/alias-tips
              unixorn/fzf-zsh-plugin
              chrissicool/zsh-256color
              srijanshetty/docker-zsh
              zsh-users/zsh-completions kind:fpath path:src
              romkatv/powerlevel10k kind:fpath
              zdharma-continuum/history-search-multi-word
              trystan2k/zsh-tab-title
            ''
          ];
        };

        plugins = [
          {
            name = "aliases";
            src = "${dotfiles}/.config/zsh";
            file = "aliases.zsh";
          }
          {
            name = "completion";
            src = "${dotfiles}/.config/zsh";
            file = "completion.zsh";
          }
          {
            name = "keybinds";
            src = "${dotfiles}/.config/zsh";
            file = "keybinds.zsh";
          }
          {
            name = "config";
            src = "${dotfiles}/.config/zsh";
            file = "config.zsh";
          }
          {
            name = "powerlevel10k-config";
            src = "${dotfiles}/.config/zsh";
            file = ".p10k.zsh";
          }
        ];

        initContent =
          let
            before = lib.mkBefore ''
              fastfetch
            '';
            after = lib.mkOrder 1500 ''
              autoload -Uz promptinit && promptinit && prompt powerlevel10k
            '';
          in
          lib.mkMerge [
            before
            after
          ];
      };
    }
  ];
}
