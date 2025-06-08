{ config, lib, ... }:
let
  inherit (lib) merge mkIf disabled;
in
merge
<| mkIf config.isDesktop {
  services.desktopManager.plasma6 = disabled;
}
