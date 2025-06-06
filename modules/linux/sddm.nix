{ lib, config, ... }:
let
  inherit (lib) enabled merge mkIf;
in
merge
<| mkIf config.isDesktop {
  services.displayManager.sddm = enabled;
}
