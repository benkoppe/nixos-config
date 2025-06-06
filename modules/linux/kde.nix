{ config, lib, ... }:
let
  inherit (lib) merge mkIf enabled;
in
merge
<| mkIf config.isDesktop {

  services.displayManager.sddm = enabled;
  services.desktopManager.plasma6 = enabled;

  # Configure keymap in X11
  services.xserver = enabled {
    xkb = {
      layout = "us";
      variant = "";
    };

    libinput = enabled {
      mouse = {
        accelProfile = "flat";
      };
    };
  };
}
