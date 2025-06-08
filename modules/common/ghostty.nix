{ config, lib, ... }:
let
  inherit (lib) enabled merge mkIf;
in
merge
<| mkIf config.isDesktop {
  environment.variables = {
    TERMINAL = mkIf config.isLinux "ghostty";
    TERM_PROGRAM = mkIf config.isDarwin "ghostty";
  };

  home-manager.sharedModules = [
    {
      programs.ghostty = enabled {
        # Bat syntax points to emptyDirectory
        installBatSyntax = !config.isDarwin;

        settings =
          merge
            {
              window-colorspace = "display-p3";
              theme = "0x96f";

              font-family = "MesloLG Nerd Font Mono";
              font-size = 10;

              window-padding-x = 5;
              window-padding-y = 10;

              confirm-close-surface = false;
              mouse-shift-capture = false;
            }
            (
              mkIf config.isLinux {
                window-decoration = "none";
                gtk-adwaita = false;
              }
            );
      };
    }
  ];
}
