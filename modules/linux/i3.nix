{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    merge
    mkIf
    enabled
    disabled
    ;
in
merge
<| mkIf config.isDesktop {

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  services.xserver = enabled {
    desktopManager.xterm = disabled;

    windowManager.i3 = enabled {
      extraPackages = with pkgs; [
        rofi
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  home-manager.sharedModules = [
    {
      xsession.windowManager.i3 = enabled {
        config = {
          modifier = "Mod4";
        };
      };
    }
  ];
}
