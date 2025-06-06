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
        i3lock
        i3blocks
      ];
    };
  };

}
