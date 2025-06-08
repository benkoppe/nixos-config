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
    mkOptionDefault
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
    (
      let
        modifier = "Mod4";
      in
      {
        xsession.windowManager.i3 = enabled {
          config = {
            modifier = modifier;
            keybindings = mkOptionDefault {
              "${modifier}+b" = "exec brave";
            };
          };
        };
      }
    )

    # fix broken spice-vdagent on i3
    (mkIf config.isVM {
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

      xsession.windowManager.i3.config.startup = [
        {
          command = "spice-vdagent";
          always = true;
        }
        {
          command = "${resizeScriptPath} &";
          always = true;
        }
      ];
    })
  ];
}
