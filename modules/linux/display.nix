{ config, lib, ... }:
let
  inherit (lib)
    enabled
    mkIf
    merge
    mkDefault
    mkForce
    ;
in
merge
  (mkIf config.isDesktop {
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

    # Enable auto login
    # services.displayManager.autoLogin.enable = true;
    # services.displayManager.autoLogin.user = "test";

    home-manager.sharedModules = [
      {
        xsession.initExtra = mkDefault "";
      }
    ];

  })
  (
    mkIf config.isVM {
      # Add qemu-guest-agent
      services.qemuGuest.enable = true;
      # Add spice-vdagent
      services.spice-vdagentd.enable = true;

      home-manager.sharedModules = [
        {
          # don't turn off 'display'
          xsession.initExtra = mkForce "xset s off -dpms";
        }
      ];
    }
  )
