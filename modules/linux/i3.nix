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
  resizeScriptPath = ".local/bin/resize-on-randr.sh";
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
      home.file."${resizeScriptPath}" = {
        text = ''
          #! /usr/bin/env nix-shell
          #! nix-shell -i bash -p bash

          xev -root -event randr |
            grep --line-buffered 'subtype XRROutputChangeNotifyEvent' |
            while read _; do
              xrandr --output Virtual-1 --auto
            done
        '';
        executable = true;
      };

      xsession.windowManager.i3 = enabled {
        config = {
          modifier = "Mod4";
          startup = [
            {
              command = "spice-vdagent";
              always = true;
            }
            {
              command = "${resizeScriptPath} &";
              always = true;
            }
          ];
        };
      };

      # xsession.initExtra = ''
      #   spice-vdagent
      #   $(
      #     xev -root -event randr |
      #       grep --line-buffered 'subtype XRROutputChangeNotifyEvent' |
      #       while read _; do
      #         xrandr --output Virtual-1 --auto
      #       done
      #   ) &
      # '';
    }
  ];
}
