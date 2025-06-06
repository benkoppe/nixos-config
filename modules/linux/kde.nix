{ config, lib, ... }:
let
  inherit (lib) merge mkIf enabled;
in
merge
<| mkIf (builtins.false && config.isDesktop) {
  services.desktopManager.plasma6 = enabled;
}
