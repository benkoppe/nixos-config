{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) merge mkIf enabled;
in
merge (
  mkIf config.isDesktop {
    # use tuigreet as displayManager
    services.displayManager = {
      tuigreet = enabled;
      defaultSession = "none+i3";
    };
    services.greetd = enabled {
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --xsessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions --sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --xsession-wrapper";
          user = "greeter";
        };
      };
    };
  }
)
