{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) enabled;
in
{
  home-manager.sharedModules = [
    {
      programs.tmux = enabled {
        shortcut = "space";

        mouse = true;
        escapeTime = 0;
        aggressiveResize = true;
        baseIndex = 1;
        keyMode = "vi";
        terminal = "tmux-256color";
        historyLimit = 50000;

        sensibleOnTop = true;
        plugins = with pkgs; [
          tmuxPlugins.resurrect
          tmuxPlugins.continuum
          tmuxPlugins.cpu
          tmuxPlugins.extrakto
          tmuxPlugins.tmux-which-key
          {
            plugin = tmuxPlugins.mkTmuxPlugin {
              pluginName = "tmux-window-name";
              version = "1.0.0";
              src = pkgs.fetchFromGitHub {
                owner = "ofirgall";
                repo = "tmux-window-name";
                rev = "master";
                sha256 = "sha256-klS3MoGQnEiUa9RldKGn7D9yxw/9OXbfww43Wi1lV/w=";
              };
            };
          }
        ];

        extraConfig = ''
          set-option -ga terminal-overrides ",*:Tc"

          set -g set-titles on
          set -g renumber-windows on

          bind-key c new-window -c  "#{pane_current_path}"

          set -g window-status-current-style bg=colour42,fg=black

          set -g status-right 'CPU: #{cpu_icon} #{cpu_percentage} RAM: #{ram_icon} #{ram_percentage} | #[bg=default] %a %h-%d %H:%M '
          set -g status-right-length 100
        '';
      };
    }
  ];

}
