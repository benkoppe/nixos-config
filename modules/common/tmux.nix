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
        tmuxKey = "space";

        mouse = true;
        escapeTime = 0;
        aggressiveResize = true;
        baseIndex = 1;
        keyMode = "vi";
        terminal = "tmux-256color";

        sensibleOnTop = true;
        plugins = with pkgs; [
          tmuxPlugins.resurrect
          tmuxPlugins.continuum
          tmuxPlugins.cpu
          tmuxPlugins.extrakto
          tmuxPlugins.tmux-which-key
        ];

        extraConfig = ''
          set -g set-titles on

          bind-key c new-window -c  "#{pane_current_path}"

          set -g window-status-current-style bg=colour42,fg=black

          set -g status-right 'CPU: #{cpu_icon} #{cpu_percentage} RAM: #{ram_icon} #{ram_percentage} | #[bg=default] %a %h-%d %H:%M '
          set -g status-right-length 100
        '';
      };
    }
  ];

}
