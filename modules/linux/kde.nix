{ config, lib, ... }:
let
  inherit (lib) merge mkIf enabled;
in
merge
<| mkIf config.isDesktop {
  services.desktopManager.plasma6 = enabled;
}
