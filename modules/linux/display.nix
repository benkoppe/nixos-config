{ config, lib, ... }:
let
  inherit (lib) enabled mkIf merge;
in
merge
<| mkIf config.isDesktop {
  # use sddm as displayManager
  services.displayManager = {
    sddm = enabled;
    defaultSession = "none+i3";
  };

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

}
<| mkIf config.isVM {
  # Add qemu-guest-agent
  services.qemuGuest.enable = true;
  # Add spice-vdagent
  services.spice-vdagentd.enable = true;
}
