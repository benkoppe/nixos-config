{ config, lib, ... }:
let
  inherit (lib) merge mkIf;
in
merge
<| mkIf config.isDesktop {
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
