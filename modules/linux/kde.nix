{ config, lib, ... }:
let
  inherit (lib) merge mkIf enabled;
in
merge
<| mkIf config.isDesktop {

  services.displayManager.sddm = enabled;
  services.desktopManager.plasma6 = enabled;

  # Configure keymap in X11
  services.xserved = enabled {
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
