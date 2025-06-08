{ config, lib, ... }:
let
  inherit (lib) enabled mkIf merge;
in
merge
<| mkIf config.isDesktop {
  # Configure keymap in X11
  services.xserver = enabled {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Configure inputs
  services.libinput = enabled {
    mouse = {
      accelProfile = "flat";
    };
  };

  home-manager.sharedModules = [
    {
      xsession.initExtra = ''
        # auto resize in response to VM resizes
        spice-vdagent
        $(
          xev -root -event -randr |
            grep --line-buffered 'subtype XRROutputChangeNotifyEvent' |
            while read ; do
              xrandr --output Virtual-1 --auto
            done
        ) &
      '';
    }
  ];
}
