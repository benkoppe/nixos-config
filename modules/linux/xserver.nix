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
}
